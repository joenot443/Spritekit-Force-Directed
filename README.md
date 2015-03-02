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

The macros SPEED, DAMPING, and MIN_ENERGY can be changed in ScrollScene to adjust portions of the simulation.

The macros REPULSION, RELATED_REPULSION, ATTRACTION, CENTER_REPEL, and CENTER_ATTRACT can be changed in Node to change the behaviour of the Nodes. Adjusting the values is a very fine balancing act, it is generally recommended to leave their default values.

Once a steady state has been reached (sceneEnergy < MIN_ENERGY), the simulation is halted. 

The easiest way to implement this project is to add ScrollScene and Node to your SpriteKit project. Initialize ScrollScene as a SpriteKit scene on a UIViewController, call buildNodes() on ScrollScene and the simulation should begin.

##TODO

Rewrite the node simulation algorithm. The present algorithm works very well for simulations below 50 nodes, but past this, the simulation slows considerably. The eventual plan is to implement the Barnes-Hut simulation algorithm. This would allow the simulation to run in O(n log n) time as opposed to the usual O(n^2). 

## Example

This is the included example using a set of 6 nodes:

![alt text](http://i.imgur.com/adl9inD.png?1 "6 Node Example")
