# IEEE-1855-Driver-for-QFIE [![Made at Quasar!](https://img.shields.io/badge/Unina-%20QuasarLab-blue)](http://quasar.unina.it) [![Made at Quasar!](https://img.shields.io/badge/Related-%20Paper-orange)](https://ieeexplore.ieee.org/)

This repo contains the code related to the IEEE Std 1855 Driver capable of converting transparent fuzzy systems
in controllers executable on quantum computers reported in:

**''G. Acampora and A. Vitiello, "An IEEE Std 1855 Driver for Synthetizing Quantum Fuzzy Inference Engines,"
    in IEEE International Conference on Fuzzy Systems, 2023, To be published.''**


## How to use

Let us consider to have the fuzzy controller modelled by means of IEEE Std 1855 and stored in the file *controller.fml*. 

The first step is to use a XSLT processor to convert the file controller.fml in a file with exestion .py capable to run the fuzzy controller on a quantum computer. Let us consider *test.py* the name of this file. The XSLT processor uses the XSLT file *qfie.xsl*.

The second step is to create the environment where the file *text.py* can be run. Firstly, it is necessary to install the module QFIE as follows:

```bash
git clone https://github.com/Quasar-UniNA/QFIE.git QFIE
cd QFIE
pip install .
```

Then, it is necessary to install the other required modules as follows:

```bash
pip install -r requirements.txt
```

The third step is to run the filw *text.py* by using the command *python* and by giving the following inputs through the command line:
- input values for the fuzzy controller in the same order as how the input fuzzy variables are listed in the IEEE Std 1855 document;
- the name of the IBM backend, the three components of the IBM provider (hub, group and project) and the token identifying the personal IBM account. This information is optional. If this information is not given, automatically, the fuzzy controller is run on the IBM quantum simulator.
