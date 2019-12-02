// CMSC 430
// Duane J. Jarc

// Edited by Sean Filer on 11/30/2019

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>
#include <iostream>

using namespace std;

#include "values.h"
#include "listing.h"

float convertRealLiteral(CharPtr realLiteral)
{
	string realLitString = realLiteral;
	float convertedValue;
	bool eFound;
	bool negativeExponent;
	bool containsUnaryOperator;
	int ePlace = realLitString.find("e");

	if(ePlace != string::npos)
	{
		eFound = true;

	} else
	{
		ePlace = realLitString.find("E");
		if(ePlace != string::npos)
		{
			eFound = true;
		} else
		{
		    eFound = false;
		}
	}

	if(eFound)
    	{
        	float baseValue = stof(realLitString.substr(0,ePlace));
		int exponentValue = stoi(realLitString.substr(ePlace + 1));
		convertedValue = baseValue * pow(10, exponentValue);
		
    	} else
    	{
        	convertedValue = stof(realLitString);
    	}

	
	return convertedValue;
}

float convertBoolLiteral(CharPtr boolLiteral)
{
	string currentBool = boolLiteral;
	if(currentBool.compare("true") == 0)
	{
		return 1;
	} else
	{
		return 0;
	}
}

float evaluateReduction(Operators operator_, float head, float tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}


float evaluateRelational(float left, Operators operator_, float right)
{
	int result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case GREATER:
			result = left > right;
			break;
		case LESSOREQUAL:
			result = left <= right;
			break;
		case GREATEROREQUAL:
			result = left >= right;
			break;
		case EQUAL:
			result = left == right;
			break;			
	}
	return result;
}

float evaluateArithmetic(float left, Operators operator_, float right)
{
	float result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case SUBTRACT:
			result = left - right;
			break;
		case DIVIDE:
			result = left / right;
			break;
		case REMAINDER:
			result = remainder(left, right);
			break;
		case EXPONENT:
			result = pow(left, right);
			break;
	}
	return result;
}

void printCurrentValue(float currentValue)
{
	cout << "printing a value!..." << currentValue << endl;
}
