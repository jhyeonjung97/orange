from __future__ import absolute_import, division, print_function, unicode_literals, unicode_literals
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
import csv
import numpy as np
import pandas as pd
import seaborn as sns
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from tensorflow.keras import callbacks
from datetime import datetime
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE

# Read input dataset
column_names = ['period', 's', 'd', 'p', 'composition', 'formation_energy']
raw_dataset = pd.read_csv("formation-energy.csv", names=column_names, sep=",")
dataset = raw_dataset.copy()
remain_dataset = dataset.sample(frac=0.9, random_state=0)test_dataset = dataset.drop(remain_dataset.index)
train_dataset = remain_dataset.sample(frac=0.9, random_state=0)val_dataset = remain_dataset.drop(train_dataset.index)

# Scatter plot
sns.pairplot(raw_dataset, diag_kind='kde', hue='d', palette='coolwarm', plot_kws={"s": 15})
plt.show()

# Statics
train_stats = train_dataset.describe()
train_stats.pop("formation_energy")train_stats = train_stats.transpose()

# Labels
train_labels = train_dataset.pop('formation_energy')
val_labels = val_dataset.pop('formation_energy')
test_labels = test_dataset.pop('formation_energy')

# Normalization
def norm(x):
    return (x - train_stats['mean']) / train_stats['std']
normed_train_data = norm(train_dataset)
normed_val_data = norm(val_dataset)
normed_test_data = norm(test_dataset)

# Build model
def build_model(l, n, lr, a, d, r):
    model = keras.Sequential()
    model.add(layers.Dense(n, activation=a, input_shape=[len(train_dataset.keys())]))
    for _ in range(1, l):
        model.add(layers.Dense(n, activation=a))
        n = n - 1
        model.add(layers.Dropout(rate=d))
        model.add(layers.Dense(1, activation='linear', kernel_regularizer=l2(r)))
        optimizer = tf.keras.optimizers.Nadam(learning_rate=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-07)
        model.compile(loss='mae', optimizer=optimizer, metrics=['mae', 'mse'])
        return model

# Traning & Evaluation
def evaluate_model(i, l, n, lr, a, d, r):
    model = build_model(l=l, n=n, lr=lr, a=a, d=d, r=r)
    filepath = "my_model/{}_{}_{}_{}_{}_{}_{}.h5".format(i, l, n, lr, a, d, r)
    tn = callbacks.TerminateOnNaN()
    es = callbacks.EarlyStopping(monitor='val_loss', patience=5)
    mc = callbacks.ModelCheckpoint(filepath=filepath, monitor='val_loss', mode='min', save_best_only=True)
    hist = model.fit(normed_train_data, train_labels, epochs=50000, validation_data=(normed_val_data, val_labels), callbacks=[tn, es, mc])
    if 'val_loss' not in hist.history:
        return 0
    else:
        val_loss = hist.history['val_loss']
        if np.isinf(val_loss[-1]) or np.isnan(val_loss[-1]):
            return 0
        else:
            mae = min(val_loss)
            eph = val_loss.index(mae)
            loss = val_loss[eph]
            if np.isinf(mae) or np.isnan(mae) or mae > 0.3:
                return 0
            else:
                with open("my_result/result.csv", 'a', newline='') as file:
                    writer = csv.writer(file)
                    writer.writerow([i, l, n, lr, a, d, r, loss, mae])
                    return 1

# Hyperparameter tuning 
HP = [[3, 5, 7, 9, 11],  # hidden layer
      [3, 5, 7, 9, 11],  # node
      [0.05, 0.03, 0.02, 0.01, 5e-03, 1e-03, 5e-04, 1e-04], # learning rate
      ['elu', 'exponential', 'hard_sigmoid', 'relu', 'selu', 'sigmoid', 'softmax', 'tanh'],
      [0, 0.2, 0.3, 0.4, 0.5],  # dropout
      [0.02, 0.01, 0.005, 0.0001, 0]]  # l2 regularization
STOP = np.zeros((len(HP[0]), len(HP[1]), len(HP[2]), len(HP[3]), len(HP[4]), len(HP[5])))

for i in range(0, 10):
    for l in HP[0]:
        for n in HP[1]:
            if n + 1 > l:
                for lr in HP[2]:
                    for a in HP[3]:
                        for d in HP[4]:
                            for r in HP[5]:
                                if i == 0:
                                    STOP[HP[0].index(l), HP[1].index(n), HP[2].index(lr), HP[3].index(a), HP[4].index(d), HP[5].index(r)] = evaluate_model(i, l, n, lr, a, d, r)
                                elif STOP[HP[0].index(l), HP[1].index(n), HP[2].index(lr),
                                          HP[3].index(a), HP[4].index(d), HP[5].index(r)] == 1:
                                    STOP[HP[0].index(l), HP[1].index(n), HP[2].index(lr), HP[3].index(a), HP[4].index(d), HP[5].index(r)] = evaluate_model(i, l, n, lr, a, d, r)

# t-SNE
column_names = ['period', 's', 'd', 'p', 'composition', 'formation_energy']
raw_dataset = pd.read_csv("formation-energy.csv", names=column_names, sep=",")
labels = raw_dataset.pop('d')
model = TSNE(learning_rate=100)
transformed = model.fit_transform(raw_dataset)
xs = transformed[:, 0]
ys = transformed[:, 1]
plt.scatter(xs, ys, c=labels)
plt.show()