
Contents:
- Device overview
- Fabrication
- References


## Device Overview
Behavioral imaging arenas (~600um height) confine movement of hydra quaso-2D. Animal exhibits correlates of many freely moving animal behaviors. Animals are loaded one per chamber to limit interaction between individuals. This method for immobilization allows imaging animals for days. Refer to HIPSTER to see how to use these devices for long-term time-lapse imaging of behaviors. 

Photomasks notes:

Devices with very large features can be fabricated with 3D printed master molds. We use Forms2 3D printer with clear resin and Autodesk Inventor (or any other CAD software) to design the chambers.

Softlithography method requires multiple resin layers to reach the desired chamber height (~600um). It helps to have programmable hot plate for slow temperature ramps to reduce stress that causes wrinkling of the photoresist. We designed layouts with LEdit and obtain the transparency photomasks from CAD/ART services.

## Fabrication
### Microfluidic Master mold - Hydra layer

Method 1 - 3D print:
      Design layouts with Autodesk inventor
      FormLabs 3D printer (clear resin)
    
Method 2 - Sofft Lithography:
    * Soft-lithography for very thick photoresist layer is prone to thermal stress. Avoid exposure to excessive humidity and sudden temperature change.*

    1. Clean wafer:

        Heat 4” Si wafer @250C for 5min
        Oxygen plams clean: 5 min ~100W, 10Torr

    2. Spin coat 3 layers of SU8-2075 for ~220um thickness each (3 layers for ~600um, 2 layers for 440um, etc)

      Layer 1

        Spin recipe: 
          Step 1: 300rpm - 100rpm/s - 20s
          Step 2: 1150rpm - 500rpm/s - 30s

        Pre-Bake:
          _Programmable hot plate (takes several hours)_
          40 min @ 65C 
          10c/hr ramp to 85C 
          45 min @ 85C 
          cool to RT on plate

      Layer 2

        Spin recipe:
        Step 1: 300rpm - 100rpm/s - 20s
        Step 2: 1150rpm - 500rpm/s - 30s

      Pre-Bake:
        40 min @ 65C
        4c/hr ramp to 82C 1hr
        5c/hr ramp to  90C for 30 min
        cool on hot plate

      Layer 3

        Spin recipe:
          Step 1: 300rpm - 100rpm/s - 20s
          Step 2: 1150rpm - 500rpm/s - 30s

        Pre-Bake:
          40 min @ 65C
          4c/hr ramp to 82C 1hr
          5c/hr ramp to  90C for 30 min
          5c/hr ramp to 60C for 5 min
          Cool to RT on plate
    
    3.	Expose 
      ~ 800 mJ/cm2 with UV filter
      Expsure dose may need to be adjusted depending on layout or lamp age
    
    4.	Post-bake
      15 min @ 65C 
      200C/hr ramp to 85C for 10 min (should start to see the pattern emerge)
      10 min @ 95C
      coot to RT
    
    5.	Develop 
      20 minutes in SU-8 developer (if it takes too long replace with new developer)
      IPA rinse
      Air dry
    
    6.	Hard Bake:
      40 min @ 65C
      100C/hr ramp to 160C 30 mins
      Cool to RT slowly (if the subtrate is heated/cooled too fast, the photoresist may crack and peel off the device due to high thermal stress)
      
      
      



### PDMS
#### Moulding PDMS
      1. Thoroughly Mix PDMS (Sylgard 184)  monomer and crosslinker 10:1 (w/w) for 10 mins (~30:3g for one 4”Si wafer). (Note: mixing for ~10 mins is important to make peeling PDMS from mold easier.)
      2. Make walls around the master mold (Si wafer) with Alumuminum foil and pour the PDMS mixture in.
      3. Degas in vacuum chamber to remove air bubbles (~ -30mmHg)
      4. Cure PDMS in oven 60C for ~40 mins. (Note: overbaking for >4hrs make peeling the pdms very difficult on mold with small channels.)
      5. Gently peel the hardened elastomer (PDMS) from the mold

#### Assembling microfluidic devices
      1. Cut around the chambers.	
      2. Using (1mm or 1.25mm) biopsy punches, punch holes for the inlets/outlets ports
      3. Clean the microfluidic chips (with scotch tape) and glass slides (with warm soapy water and IPA/ethanol)
      4. Oxygen plasma treat the glass and microfluidic chips with patterned side up (https://harrickplasma.com/plasma-cleaners/ sec at 300mTorr, high power)
      5. Press the microfluidic chip with pattern side on to the treated side of the glass. Remove any air bubbles.
      6. Heat cure the device (60c for ~10 mins, longer is better) to strengthen the adhesion. The device is ready to use!!!








## References:
1. Badhiwala, K. N., Gonzales, D. L., Vercosa, D. G., Avants, B. W. & Robinson, J. T. Microfluidics for electrophysiology, imaging, and behavioral analysis of: Hydra. Lab Chip 18, 2523–2539 (2018).
