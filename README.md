# Spritekit Force Directed Graph Engine

## Intro

While developing a music library visualization tool (still in development), I ran into the challenge of designing a system to generate a force directed graph in iOS. There was no library currently available, so I built this implementation.

## Usage

Data (colour, size, and relatedness) is read from the Node.plist file. Nodes are stored as dictionaries, as follows:

```plist
plist version="1.0">
<dict>
	<key>Node6</key>
	<dict>
		<key>RelatedNodes</key>
		<array>
			<string>Node1</string>
		</array>
		<key>Colour</key>
		<integer>3</integer>
		<key>Size</key>
		<integer>30</integer>
	</dict>
```

Nodes are created and simulated in the ScrollScene.m file. Panning and zooming the SpriteKit scene  is largely based off of the excellent ScrollKit project by bobmoff (https://github.com/bobmoff/ScrollKit). 

The simulation relies on a modified implementation of Hooke's Law and Coulomb's Law to calculate the forces on every node. This is the 'classic' approach to force directed graphs.

The macros SPEED, DAMPING, and MIN_ENERGY can be changed in ScrollScene to adjust portions of the simulation.

The macros REPULSION, RELATED_REPULSION, ATTRACTION, CENTER_REPEL, and CENTER_ATTRACT can be changed in Node to change the behaviour of the Nodes. Adjusting the values is a very fine balancing act, it is generally recommended to leave their default values.

Once a steady state has been reached (sceneEnergy < MIN_ENERGY), the simulation is halted. 

The easiest way to implement this project is to add ScrollScene, Node, VectorMath and EdgeNode to your SpriteKit project. Initialize ScrollScene as a SpriteKit scene on a UIViewController, call buildNodes() on ScrollScene and the simulation should begin.

##TODO

Rewrite the node simulation algorithm. The present algorithm works very well for simulations below 50 nodes, but past this, the simulation slows considerably. The eventual plan is to implement the Barnes-Hut simulation algorithm. This would allow the simulation to run in O(n log n) time as opposed to the usual O(n^2). 

## Example

This is the included example using a set of 6 nodes:

![alt text](http://i.imgur.com/adl9inD.png?1 "6 Node Example")

##License

License
The MIT License (MIT)

Copyright (c) 2015 Joe Crozier

Some additions Copyright (c) 2014 IMGNRY International AB [ScrollKit implementation]

Some additions Copyright (c) 2014 Enharmonic inc (iOS Zooming and OSX version) [ScrollKit Implementation



Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
