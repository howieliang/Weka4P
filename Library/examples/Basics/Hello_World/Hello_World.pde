//*********************************************
//  Hello World : Bare minimium to check if the library is loading
//
//  Author: Wesley Hartogs <dev@wesleyhartogs.nl>
//
//  Version: 1.0.0 (15 04 2021)
//
//  Manual:
//  Start the program.
//  If the current version of the library 
//  is shown in in the console then the library is
//  installed correctly.
//*********************************************

import Weka4P.*;                                       // Import the Weka4Processing library
Weka4P wp;                                             // Global Weka4P variable

void setup() {
    size(500, 500);
    wp = new Weka4P(this);                             // Initialize Weka4P object
    
    wp.printVersion();                                 // Prints the current version of Weka4P
}
