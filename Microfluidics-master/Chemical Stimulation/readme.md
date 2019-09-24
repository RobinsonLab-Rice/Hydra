
Contents:
- Device overview
- Fabrication
- References


## Device Overview
Chemical Perfusion devices (~125um height) confine movement of hydra to quasi-2D. Animal is able to contract, elongate, and open/close mouth. The small perfusion channels allow chemical/buffer to be flowed slowly around hydra without mechanically stimuating hydra.

Photomasks notes:
We designed layouts with LEdit and obtain the transparency photomasks from CAD/ART services.

## Fabrication
### Microfluidic Master mold - Hydra layer

    1. Clean wafer:

        Heat 4” Si wafer @250C for 5min
        Oxygen plasma clean: 5 min ~100W, 10Torr
    
    Perfusion Layer
    2. Spin coat SU8-3025 for ~25 um thickness  
     
        Spin recipe: 
          Step 1: 300rpm - 100rpm/s - 20s
          Step 2: 3000rpm - 300rpm/s - 30s

    3. Pre-Bake:
          3 min @ 65C 
          10 min @ 95C 
    
    4.	Expose 
      ~ 250 mJ/cm2 with UV filter
      Expsure dose may need to be adjusted depending on layout or lamp age
    
    5.	Post-bake
      5 min @ 65C 
      5-7 min @ 95C
    
    6.	Develop 
      3 minutes in SU-8 developer 
      IPA rinse
      Air dry
    
    7.	Hard Bake:
      5 min @ 65C
      5 min @ 95C
      5 min @ 120C
      40 min @ 180C
      Cool to RT slowly (if the subtrate is heated/cooled too fast, the photoresist may crack and peel off the device due to high thermal stress)
      
      Hydra Layer
    2. Spin coat SU8-2075 for ~100 um thickness  
     
        Spin recipe: 
          Step 1: 300rpm - 100rpm/s - 20s
          Step 2: 1800rpm - 300rpm/s - 30s

    3. Pre-Bake:
          10 min @ 65C 
          30 min @ 95C 
          May require slow temperature ramping if photoresist forms deformities in form of bubbles or wrinkles.
    
    4.	Expose 
      align the mask to previous layer of photoresist using the alignment marks.
      ~ 350 mJ/cm2 with UV filter
      Expsure dose may need to be adjusted depending on layout or lamp age
    
    5.	Post-bake
      10 min @ 65C 
      30 min @ 95C
    
    6.	Develop 
      8 minutes in SU-8 developer 
      IPA rinse
      Air dry
    
    7.	Hard Bake:
      5 min @ 65C
      5 min @ 95C
      5 min @ 120C
      40 min @ 180C
      Cool to RT slowly (if the subtrate is heated/cooled too fast, the photoresist may crack and peel off the device due to high thermal stress)
      
     

## References:
1. Badhiwala, K. N., Gonzales, D. L., Vercosa, D. G., Avants, B. W. & Robinson, J. T. Microfluidics for electrophysiology, imaging, and behavioral analysis of: Hydra. Lab Chip 18, 2523–2539 (2018).
