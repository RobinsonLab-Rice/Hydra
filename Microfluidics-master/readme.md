# Contents:
- Types of devices
- General Fabrication
  - Microfluidic Molds
  - PDMS
- General use info
  - Hydra Loading/Unloading
  - Device Cleaning

_Notes:_ 
- _This guide assumes access to and working knowledge of cleanroom equipments for soft-lithography (Mask aligner, plasma clearner, spinners, hot plate)._
- _We use transprency photomasks for the microfluidic devices (feature size/channel width >20 um)._
- _We use glass photomasks for nano-SPEAR ephys devices._



## Types of devices
- *Simple Immobilization:* Used for whole-brain imaging. Single layer immobilization chamber with ~100um height
- *nano-SPEAR ephys:* Used for measuring electrical activity from epithelial cells and whole-brain imaging. Tightest confinement
- *Behavioral Imaging Arena:* Used for non-interacting multiple whole-animal movement/behavior tracking. Hydra lanes are ~ 600um height with 'least' confinement.
- *Sensory Stimulation Devices:*
  - *Chemical Stimulation:* Used for whole-brain imaging while perfusing chemicals. Double layer photolithography for perfusion layer (~ 25 um height) and flow layer (~ 100um). Single layer PDMS with multiple height channels.
  - *Stay tuned for more devices!!!*

## General Fabrication
### Microfluidic Molds
    Materials:
      4" wafer
      SU8-2075
      Photomask
      SU8 developer
      IPA
      Oxygen plasma cleaner
      Mask aligner (UV lamp)
      Photoresist Spinner
      Hot plate


    1. Oxygen Plasm Clean
      10 min at ~100 W, 10 Torr
    2. Spin SU8-2075
      Spin speed depends on channel height. (see detailed steps for the specific devices.)
    3. Pre-bake 
      Bake times depend on channel height. (see detailed steps for the specific devices.)
    4. Expose
      Exposure dose depend on channel height. (see detailed steps for the specific devices.)
      Use UV filter
      We use transparency photomasks for most microfluidic devices. (see specific device directory for layouts).
    5. Post-bake
      Bake times depend on channel height. (see detailed steps for the specific devices.)
    6. Develop
      SU8 developer
      IPA rinse
      Bake times depend on channel height. (see detailed steps for the specific devices.)
    7. Hard-bake
      1 hr at 180C

### PDMS
#### Moulding PDMS
      1. Thoroughly Mix PDMS (Sylgard 184)  monomer and crosslinker 10:1 (w/w) for 10 mins (~30:3g for one 4”Si wafer). (Note: mixing for ~10 mins is important to make peeling PDMS from mold easier.)
      2. Make walls around the master mold (Si wafer or 3D printed mold) with Alumuminum foil and pour the PDMS mixture in.
      3. Degas in vacuum chamber to remove air bubbles (~ -30mmHg)
      4. Cure PDMS in oven 60C for ~40 mins. (Note: overbaking for >4hrs makes peeling the pdms very difficult esp. for mold with small channels.)
      5. Gently peel the hardened elastomer (PDMS) from the mold

#### Assembling microfluidic devices
      1. Cut around the chambers.	
      2. Using (1mm or 1.25mm) biopsy punches, punch holes for the inlets/outlets ports
      3. Clean the microfluidic chips (with scotch tape) and glass slides (with warm soapy water and IPA/ethanol)
      4. Oxygen plasma treat the glass and microfluidic chips with patterned side up (https://harrickplasma.com/plasma-cleaners/ sec at 300mTorr, high power)
      5. Press the microfluidic chip with pattern side on to the treated side of the glass. Remove any air bubbles.
      6. Heat cure the device (60c for ~10 mins, longer is better) to strengthen the adhesion. The device is ready to use!!!


## General use information 
### Hydra Loading/Unloading 
    Materials:
      BD 10mL Syringe Luer-Lok tip (REF302995)
      LS18 18ga x ½” Luer Stubs (www.instechlabs.com)
      Tubing 0.045 ”I.D. x 0.063” O.D. www.scicominc.com catalog # BB31695-PE/7)

#### Device Prep:
  
    1. Fill syringe with filetered Hydra media. 
    2. Attach appropriately sized Luer stubs and tygon tuning to the syringe. 
    3. Inserttygon tubing into the punched ports in the microfluidic devices and thoroughly wet the chamber with hydra media. Carefully removing all air bubbles.
    
#### Hydra Loading:
  
    1. Remove tubing from an inlet port. 
    2. Pull a Hydra few millimeters into the tubing with syringe then reinserting the tubing into the inlet port of the microfluidic device. 
    2. Inject hydra into the chamber by applying slight positive pressure to the inlet syringe. 
    3. The two opposing syringes can be alternatively used to provide gentle pulses to position the Hydra in the observation chamber. (If Hydra sticks to the tubing, gently tapping the area near hydra should help). Begin experiments!!! 
    
#### Hydra Unloading:
   
    1. To remove hydra from the microfluidic device, gently apply positive pressure to one of the syringes while applying negative pressure to the outlet syringe.
    2. Pulsing the syringe gently should remove hydra with minimal damage.
    3. If the animal health is not important (ie discard hydra), then remove tubing from one of the ports and apply high pressure to the syringe plugged into the port on the opposite side of the device. Hydra will flow out.

### Cleaning microfluidic devices
    1. Flush the channels with DI water using syringe fitted with 0.2um filter (~30mL)
    2. Submerge the device in DI water and sonicate for ~10 min.
    3. Heat the device in DI water to 160C for 1hr.
    3. If the device was used with chemical, soak in new DI water overnight (replacing DI water every few hours, if possible)
    4. Dry the device with compressed air and  in bake in oven at 45C ~8 hrs. (Note: lower temperature prevents PDMS from stiffening too much)



