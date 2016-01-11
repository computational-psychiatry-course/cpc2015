# Computational Psychiatry Course - Zurich 2015 #

## Preparation ##

Compile the pomdp-solve toolbox. The toolbox (./pomdp-solve-5.4) is from http://pomdp.org/ and is given here for convenience only.

- Follow the instructions in ./pomdp-solve-5.4/INSTALL. 
- You should get in the end a pomdp-solve file. It contains the main code for solving the POMDPS.
- Copy the pomdp-solve file in the main folder. 

## Definition of the problem ##

The tiger.POMDP file describes the model (transition matrices, reward functions, observations, etc.). 
You can modify this file to test the influence of the model parameters on the optimal behaviour.

## Solving the problem ##

* In matlab, call the function

    ```results = solvePOMDP('tiger') ```

    This script will run the pomdp-solve C code, load the solution and format it in a more readable matlab structure.
    If you prefer to go step by step, you can directly call the podmp-solve code by typing in your terminal:

    ``` ./pomdp-solve -pomdp tiger.POMDP -o 'tiger-solution' ```

* The toolbox produces two files containg the solution of the pomdp:

    - 'tiger-solution.alpha' is the list of the alpha-vectors defining the optimal value function, as following
    - 'tiger-solution.pg'    is the optimal policy of the corresponding belief MDP. Each line indicates:
        - the belief state number
        - the best action for this state
        - the next belief state to be reached for depending on the observation (so as many columns as possible observations)

    In case you cannot run the pomd-solve code, the solution of the problem is already included in the folder.
