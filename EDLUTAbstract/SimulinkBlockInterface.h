/***************************************************************************
 *                            SimulinkBlockInterface.h                     *
 *                           -------------------                           *
 * copyright            : (C) 2011 by Jesus Garrido                        *
 *                                                                         *
 * email                : jgarrido@atc.ugr.es                              *
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

#ifndef SIMULINKBLOCKINTERFACE_H_
#define SIMULINKBLOCKINTERFACE_H_

/*!
 * \file SimulinkBlockInterface.h
 *
 * \author Jesus Garrido
 * \date May 2011
 *
 * This file declares a class for interfacing a simulink block with an EDLUT abstraction simulation object.
 */

#include "simstruc.h"
#include <string>

using namespace std;

/*!
 * \struct LStruct
 * 
 * \brief Struct abstracting a learning rule.
 *
 * \author Jesus Garrido
 * \date May 2011
 */
struct LStruct {
	
	/*!
	 * Weight decrement step.
	 */
	double LTDStep;

	/*!
	 * Weight increment step.
	 */
	double LTPStep;

	/*!
	 * Threshold determing if LTD or LTP activate.
	 */
	double Threshold;

	/*!
	 * Min threshold
	 */
	double MinThreshold;

	/*!
	 * Max LTD Step
	 */
	double MaxLTD;

	/*!
	 * Min LTD Step
	 */
	double MinLTD;

	/*!
	 * Max LTP Step
	 */
	double MaxLTP;

	/*!
	 * Min LTP Step
	 */
	double MinLTP;

};

typedef struct LStruct LearningRule;

/*!
 * \class SimulinkBlockInterface
 *
 * \brief Class for interfacing a simulink block with an EDLUT simulation object.
 *
 * This class abstract methods for running a simulation with EDLUT inside a simulink block.
 *
 * \note The block parameters must be the following:
 * - 1st parameter: Learning configuration file.
 * - 2nd parameter: Number of joints.
 * - 3rd parameter: Number of input states.
 * - 4th parameter: Ouput weights file.
 *
 * \author Jesus Garrido
 * \date May 2011
 */
class SimulinkBlockInterface {

	private:

		/*!
		 * Input/output purkinje cell table (NStates*NJoints).
		 */
		double ** PCTable;

		/*!
		 * PC Activity per joint (NJoints).
		 */
		double * PCActivity;

		/*!
		 * MF Activity per joint (NJoints).
		 */
		double * MFActivity;

		/*!
		 * DCN Activity per joint (NJoints).
		 */
		double * DCNActivity;

		/*!
		 * PC Synaptic Weight (NJoints).
		 */
		double * PCWeights;

		/*!
		 * MF Synaptic Weight (NJoints).
		 */
		double * MFWeights;		
		
		/*!
		 * PFPC Learning Rule
		 */
		LearningRule * PFPCLearning;

		/*!
		 * MFDCN Learning Rule
		 */
		LearningRule * MFDCNLearning;

		/*!
		 * PCDCN Learning Rule
		 */
		LearningRule * PCDCNLearning;

		/*!
		 * Number of joints
		 */
		unsigned int NumberOfJoints;

		/*!
		 * Number of states
		 */
		unsigned int NumberOfStates;

		/*!
		 * Final weight File
		 */
		string WeightFile;

		/*!
		 * Number of weight files
		 */
		unsigned int WeightNumber;

		/*!
		 * \brief Read a configuration file
		 */
		bool ReadLearningConfig(string ConfigFile);

		/*!
		 * \brief Save the current weight state
		 */
		bool SaveWeights(string ConfigFile, unsigned int iteration);

		/*!
		 * \brief Load the weight state
		 */
		bool LoadWeights(string WeightFile);


	public:
		/*!
		 * \brief Class constructor.
		 *
		 * It creates a new object..
		 */
		SimulinkBlockInterface();

		/*!
		 * \brief Class destructor.
		 *
		 * It destroys a new object..
		 */
		~SimulinkBlockInterface();

		/*!
		 * \brief Initialize a new simulation object
		 *
		 * It initializes a new simulation object with the values obtained from the simulink
		 * block parameters.
		 *
		 * \param S Pointer to the simulink struct of this block.
		 *
		 * \note This function is though to be called from mdlStart function.
		 */
		void InitializeSimulation(SimStruct *S);

		/*!
		 * \brief Simulate the next simulation step.
		 *
		 * It simulates the next simulation step.
		 *
		 * \param S Pointer to the simulink struct of this block.
		 * \param tid Current simulation time.
		 *
		 * \note This function is though to be called from mdlUpdate function. First, it gets
		 * the inputs from the simulation block and then it simulates the step.
		 */
		void SimulateStep(SimStruct *S, int_T tid);

		/*!
		 * \brief Assign the simulation outputs to the block outputs.
		 *
		 * It assigns the simulation outputs to the block outputs.
		 *
		 * \param S Pointer to the simulink struct of this block.
		 *
		 * \note This function is though to be called from mdlOutputs function. It doesn't simulate
		 * the step, it only assigns the outputs.
		 */
		void AssignOutputs(SimStruct *S);

};

//#include "../../../src/interface/simulink/SimulinkBlockInterface.cpp"

#endif /* SIMULINKBLOCKINTERFACE_H_ */
