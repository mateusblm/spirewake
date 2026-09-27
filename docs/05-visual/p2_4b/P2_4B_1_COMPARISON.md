# Validation comparison - armor_blackguard_01 / front_3q / right

| | before | after |
|---|---:|---:|
| rig verified (GR022/GR023) | True | True |
| errors | 14 | 12 |
| warnings | 26 | 22 |
| ok | False | False |

| slot | texture before -> after | errors before -> after | drift px before -> after | angle deg before -> after | resolved | new |
|---|---|---|---:|---:|---|---|
| forearm_hand_l | vss_armor_blackguard_01_forearm_hand_l_front3q.jpg -> vss_armor_blackguard_01_forearm_hand_l_front3q.png | 3 -> 1 | 40.0 -> 1.0 | -48.5 -> +1.2 | GR012 | - |
| forearm_hand_r | vss_armor_blackguard_01_forearm_hand_r_front3q.jpg -> vss_armor_blackguard_01_forearm_hand_r_front3q.jpg | 3 -> 3 | 6.7 -> 6.7 | -7.9 -> -7.9 | - | - |
| lower_leg_boot_l | vss_armor_blackguard_01_lower_leg_boot_l_front3q.png -> vss_armor_blackguard_01_lower_leg_boot_l_front3q.png | 1 -> 1 | 2.0 -> 2.0 | -1.7 -> -1.7 | - | - |
| lower_leg_boot_r | vss_armor_blackguard_01_lower_leg_boot_r_front3q.png -> vss_armor_blackguard_01_lower_leg_boot_r_front3q.png | 1 -> 1 | 1.2 -> 1.2 | +1.0 -> +1.0 | - | - |
| thigh_l | vss_armor_blackguard_01_thigh_l_front3q.png -> vss_armor_blackguard_01_thigh_l_front3q.png | 1 -> 1 | 15.5 -> 15.5 | -15.7 -> -15.7 | - | - |
| thigh_r | vss_armor_blackguard_01_thigh_r_front3q.png -> vss_armor_blackguard_01_thigh_r_front3q.png | 1 -> 1 | 16.1 -> 16.1 | +16.4 -> +16.4 | - | - |
| torso | vss_armor_blackguard_01_torso_front3q.png -> vss_armor_blackguard_01_torso_front3q.png | 1 -> 1 | 1.1 -> 1.1 | -0.6 -> -0.6 | - | - |
| upper_arm_l | vss_armor_blackguard_01_upper_arm_l_front3q.png -> vss_armor_blackguard_01_upper_arm_l_front3q.png | 1 -> 1 | 29.3 -> 2.4 | -33.7 -> -2.7 | - | - |
| upper_arm_r | vss_armor_blackguard_01_upper_arm_r_front3q.png -> vss_armor_blackguard_01_upper_arm_r_front3q.png | 1 -> 1 | 29.0 -> 0.5 | +33.3 -> +0.6 | - | - |
| waist_tabard | vss_armor_blackguard_01_waist_tabard_front3q.png -> vss_armor_blackguard_01_waist_tabard_front3q.png | 1 -> 1 | - -> - | - -> - | - | - |

## Remaining errors (after)
- **forearm_hand_l**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.0961; allowed only during P2.4B normalization)
- **forearm_hand_r**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1536x1536 placed through scale_to_logical=0.0504; allowed only during P2.4B normalization)
- **forearm_hand_r**: GR012 source container is JPEG (signature ffd8), cannot carry alpha (vss_armor_blackguard_01_forearm_hand_r_front3q.jpg)
- **forearm_hand_r**: GR012 source has no alpha/RGBA (vss_armor_blackguard_01_forearm_hand_r_front3q.jpg)
- **lower_leg_boot_l**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.0633; allowed only during P2.4B normalization)
- **lower_leg_boot_r**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.0679; allowed only during P2.4B normalization)
- **thigh_l**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.0652; allowed only during P2.4B normalization)
- **thigh_r**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.0648; allowed only during P2.4B normalization)
- **torso**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.1250; allowed only during P2.4B normalization)
- **upper_arm_l**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.1193; allowed only during P2.4B normalization)
- **upper_arm_r**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.0952; allowed only during P2.4B normalization)
- **waist_tabard**: GR011 normalized pilot PNG is not 512x512 (raw candidate 1254x1254 placed through scale_to_logical=0.1400; allowed only during P2.4B normalization)

## Remaining warnings (after)
- forearm_hand_l: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- forearm_hand_r: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- forearm_hand_r: LAB01 distal joint lands 6.7 px from HAND_R (art axis -7.9 deg off the bone)
- lower_leg_boot_l: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- lower_leg_boot_l: LAB01 distal joint lands 2.0 px from FOOT_L (art axis -1.7 deg off the bone)
- lower_leg_boot_r: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- lower_leg_boot_r: LAB01 distal joint lands 1.2 px from FOOT_R (art axis 1.0 deg off the bone)
- thigh_l: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- thigh_l: GR052 alpha touches canvas edge: bottom
- thigh_l: LAB01 distal joint lands 15.5 px from KNEE_L (art axis -15.7 deg off the bone)
- thigh_r: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- thigh_r: GR052 alpha touches canvas edge: bottom
- thigh_r: LAB01 distal joint lands 16.1 px from KNEE_R (art axis 16.4 deg off the bone)
- torso: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- torso: GR052 alpha touches canvas edge: left
- torso: LAB01 distal joint lands 1.1 px from SHOULDER_R (art axis -0.6 deg off the bone)
- upper_arm_l: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- upper_arm_l: LAB01 distal joint lands 2.4 px from ELBOW_L (art axis -2.7 deg off the bone)
- upper_arm_r: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- waist_tabard: GR010 view back_3q not authored yet (expected at this gate for back_3q)
- waist_tabard: GR052 alpha touches canvas edge: bottom
- waist_tabard: LAB02 lowest opaque pixel lands at y=461.0, below ground_y=448
