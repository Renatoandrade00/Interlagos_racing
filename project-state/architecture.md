# Architecture & Standards

## Engine
- **Godot 4.x** with **Compatibility Renderer** (targeting Intel UHD 620 minimum hardware).

## Project Structure
- `Core/`: GameState, SaveSystem, Settings, Input.
- `Vehicles/`: VehicleBase, VehiclePhysics, VehicleController, VehicleAudio, VehicleData.
- `Tracks/`: TrackBase, Interlagos, Checkpoints, PitLane.
- `Race/`: RaceManager, Grid, LapSystem, Timing, Results.
- `AI/`: RacingLine, DriverController, Overtaking, Difficulty.
- `UI/`: HUD, Menus, Settings.
- `Audio/`: Sound management and mixers.
- `Graphics/`: Shaders, materials, post-processing profiles.
- `Tools/`: Automation scripts and benchmarking tools.

## Coding Standards
- Modular design with clean separation of physics, input, rendering, and logic.
- Externalized vehicle configuration data via YAML/JSON.
