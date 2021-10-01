---
layout: default
title: Home
permalink: /
keywords: processing.org, library, Machine Learning, Weka, Data, classification, regression, neural networks
excerpt: A Library for the Processing programming environment
---

# (Weka4P) Weka Machine Learning for Processing

We present Weka4P, an open-sourced machine learning library with APIs that support designers to use Weka’s machine-learning functionality with Processing. It attempts to provide an interface for the designers to use and make sense of machine learning (ML) behaviors with Processing languages, so they will be able to use ML correctly as design materials in their process.

## Introduction

Machine learning (ML) is now a fairly established technology that is ready for design innovation. Therefore, designers appear regularly to integrate ML in smart products and services. Nonetheless, the ``black box'' behavior of machine learning impedes the designers from understanding the capabilities and limitations of ML, so the designers usually overlook the critical practice concerns in their concept.

We present a machine learning library, namely Weka4P, which is based on Processing — a programming language that is broadly used in the design and education community. Weka4P is a layer of abstraction that is based on the Weka library. We provide an easy-to-use application programming interface (API) with handy examples for designers to perform data collection and model training as well as use and evaluate the model with rich visuals and interactivity, which could support the users to make sense of the ML behaviors in an embodied manner.

A user of Weka4P can train and use an ML model in the following workflow:
* Collecting the data: a user collects sensor data with an Arduino board and saves their training and test datasets as Attribute-Relation File Format (ARFF) files.

* Training a model: the user trains a model with the collected training dataset using a machine learning algorithm and optimizes the model with a visual hyperparameter tuning tool.
  
* Using and evaluating a model: the user uses the optimized model to build a graphical user interface (GUI) application with hardware sensors and realizes the performance of their applications with the predictions or output performance metrics of their test data.

Weka4P provides ease of prototyping, rich visuals, and interactivity. The users can use Arduino and Processing for prototyping interactive systems with the example codes. The tool provides visually rich information that guides the users to make sense of the behavior and performance of an ML algorithm. The rich interactivity that has been substantially enabled and extensively documented by the existing Arduino and Processing community can also support the designers in designing rich tangible and embodied interactions. 


---
## Download
Download (Weka4P) Weka Machine Learning for Processing version 0.1.0 in [.zip format](./download/Weka4P-2.zip). Last update, 06/25/2021.

## Installation
Unzip and put the extracted Weka4P folder into the libraries folder of your Processing sketches. Reference and examples are included in the Weka4P folder.

## Possible Conflicts
Please do uninstall/remove any weka.jar from your libraries folder or code folder (in projects) when using this library. There are possible conflicts that can occur.

## Keywords
Machine Learning, Weka, Data, classification, regression, neural networks

## JavaDoc
Have a look at the javadoc reference [here](./reference/doc). A copy of the reference is included in the .zip as well.

## Source
The source code of (Weka4P) Weka Machine Learning for Processing is available at [GitHub](https://github.com/howieliang/Weka4P), and its repository can be browsed [here](https://github.com/howieliang/Weka4P).

## Tested

**Platform** osx,windows  
**Processing** 3.5.4  
**Dependencies** Weka, mtj, arpack_combined_all, papaya, core-netlib
