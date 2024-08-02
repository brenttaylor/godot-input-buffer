# {Game Name} Design Document

## Introduction

### Game Summary Pitch

Mass Flux is a tile based puzzle game about reducing or generally manipulating the shape of a mass of cell-blocks to navigate to a goal.

### Inspiration

**Snakebird**

Snakebird provides the ingenuity for the player to control a body that isn't always helpful and will certainly get in the way more often than aid one’s plan. A long body in that game may be susceptible to support the player from falling but often can restrict and block certain movement making puzzle areas much harder  to navigate. 

**Baba is You**

Baba is You is the main inspiration towards the style and mood of the game. Especially graphics-wise to fit the 2-bit graphical prompt, the minimalist art style will hold useful to act as a base. Otherwise, the gameplay also further provides inspiration towards level design as an abstract puzzle game.

### Player Experience

In a single screen dungeon for each of the 15 levels, the player will solve a short but perhaps complex puzzle requiring planning and management. The player must learn and use their knowledge of the interactions between the player cells and various environmental items to understand how to pass through each level.

### Platform

The game is developed to be released on windows PC.

### Development Software

- Godot {Version} for programming/game engine
- Aseprite for graphics and UI
- FL Studio 12 for all music and SFX

### Genre

Single player, puzzle, casual

### Target Audience

Without heavy or complicated ideas, and intuitive-to-grasp mechanics, this game is marketed to at least casual game players who are up for puzzling challenges as well as more veteran players up for solving complicated problems

## Concept

### Gameplay Overview

The player controls a mass of player cells, each with individual status, but moves as a collective. Individual cells may die or be created which influences the total shape of the mass. By navigating through each level, the player must strategically manipulate the shape of the mass to be able to pass around or through obstacles to reach the goal. 

### Theme Interpretation (Sacrifice Is Strength)

_‘Sacrifice’ interpretation - The player voluntarily offers something they would otherwise use to their benefit to then gain something else of use in its stead._

Within the context of a puzzle game, rather than a sacrifice strictly being an optional upgrade of sorts, the timing, placement, and orientation a ‘sacrifice’ within this game instead occurs to allow the solution or progression of the puzzle. Only through careful planning of movement to remove parts of the player’s mass can the player make their way to the exit. One must often sacrifice a part of the player mass to pass through specific areas as they may be too large or encompass the wrong shape.

### Primary Mechanics

- **Walls:** A stopping force to prevent a player too large to access a certain area. Otherwise to simply restrict movement.
- **Spikes:** When a player cell walks on top of a spike, that cell will die and further simplify the player mass.
- **Holes:** The player mass can walk freely over a hole as long as at least one cell is on a floor tile. If the entire mass is over the hole, the entire player mass dies.
- **Fruit:** If a player cell moves over a fruit, it will eat the fruit and generate a new cell on the opposite side of the mass it is a part of.

### Secondary Mechanics

- **Independence:** If two player masses happen to separate, they will still move synchronously but interact with the environment independently. If then connected again, the two masses will join to act as one.
- **Set Spikes:** When a player cell walks on top of a set spike, after moving off of it, it will then become a regular spike trap.
  

## Art

### Theme Interpretation

While maintaining the very limited color palette theme, the sole use of black in white seems way too common, and a bit harsh as a color scheme for a relaxing puzzle game. To circumvent this, a soft, dark blue color will act as the unique accent color as opposed to black with white being the primary, carrying color to base the sprites off of.

### Design

A very minimalistic approach will go into the design of the game, heavily relying on the severe contrast of the limited colors to provide detail. Though, the design still is clean and smooth in the sense that, the use of many shades of a color will not be as present to confront the retro style and pixel art.

## Audio

### Music

To add to the overall theme and vibe of the game, there will be minimalism incorporated into the music. Heavy use of reverb and effects to fill space within the few instruments. Bass and drums will generally constitute the majority of tracks with accompanying softer sounds. Mainly through synthesized sounds rather than acoustic will further suggest the retro style.

### Sound Effects

To add more flare and polish to the experience, a multitude of environmental sound effects will give weight and feedback to the player’s actions. Rather than foley, or otherwise realistic sounds, synthesized blips, bloops, and whooshes are used.

## Game Experience

### UI

On top of the rigid pixel art constituting the rest of the art, a more smooth, higher definition style will be incorporated in the UI. Utilizing many shades of white and black allowed in the art restriction, anti-aliasing is used to further emphasize the UI.

### Controls

- Keyboard: Arrow keys / WASD
- Gamepad: DPAD
