-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\habdelbagi\AppData\Local\Temp\mlhdlc_flt2fix\codegen\mlhdlc_kalman_hdl\hdlsrc\mlhdlc_kalman_hdl_fixpt.vhd
-- Created: 2015-04-13 15:44:58
-- 
--  
-- 
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Design base rate: 1
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        1
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- y1                            ce_out        1
-- y2                            ce_out        1
-- dv_out_q                      ce_out        1
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- Hamdi Abdelbagi




-- -------------------------------------------------------------
-- 
-- Module: mlhdlc_kalman_hdl_fixpt
-- Source Path: mlhdlc_kalman_hdl_fixpt
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.mlhdlc_kalman_hdl_fixpt_pkg.ALL;

ENTITY mlhdlc_kalman_hdl_fixpt IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        z                                 :   IN    vector_of_std_logic_vector14(0 TO 1);  -- sfix14_En12 [2]
        ce_out                            :   OUT   std_logic;
        y1                                :   OUT   std_logic_vector(13 DOWNTO 0);  -- sfix14_En12
        y2                                :   OUT   std_logic_vector(13 DOWNTO 0);  -- sfix14_En13
        dv_out_q                          :   OUT   std_logic  -- ufix1
        );
END mlhdlc_kalman_hdl_fixpt;


ARCHITECTURE rtl OF mlhdlc_kalman_hdl_fixpt IS

  -- Constants
  CONSTANT a_3                            : std_logic_vector(0 TO 11) := ( '1', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0' );  -- ufix1 [12]
  CONSTANT a_5                            : std_logic_vector(0 TO 11) := ( '1', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0' );  -- ufix1 [12]
  CONSTANT b0                             : std_logic_vector(0 TO 35) := 
                                                                         ( '1', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '1' );  -- ufix1 [36]
  CONSTANT a0                             : std_logic_vector(0 TO 35) := 
                                                                         ( '1', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '1' );  -- ufix1 [36]
  CONSTANT nc                             : vector_of_unsigned23(0 TO 35) := ( to_unsigned(2#00000000000000000100000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000100000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000100000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000100000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000100000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                              to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000000000000100000#, 23) );  -- ufix23 [36]
  CONSTANT b0_2                           : std_logic_vector(0 TO 11) := ( '1', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0' );  -- ufix1 [12]
  CONSTANT a_7                            : std_logic_vector(0 TO 11) := ( '1', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0' );  -- ufix1 [12]
  CONSTANT nc_2                           : vector_of_unsigned23(0 TO 3) := ( to_unsigned(2#00000000011111010000000#, 23), to_unsigned(2#00000000000000000000000#, 23),
                                                                             to_unsigned(2#00000000000000000000000#, 23), to_unsigned(2#00000000011111010000000#, 23) );  -- ufix23 [4]
  CONSTANT a0_2                           : std_logic_vector(0 TO 35) := 
                                                                         ( '1', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '1', '0', '0', '0', '0', '1', '0', '1' );  -- ufix1 [36]
  CONSTANT a_9                            : std_logic_vector(0 TO 11) := ( '1', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0' );  -- ufix1 [12]
  CONSTANT a_11                           : std_logic_vector(0 TO 11) := ( '1', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0' );  -- ufix1 [12]

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL dv_out_nr                        : std_logic;  -- ufix1
  SIGNAL niters                           : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL state                            : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL state_1                          : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL state_2                          : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL state_3                          : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL dv_out_nr_1                      : std_logic;  -- ufix1
  SIGNAL tmp                              : std_logic;
  SIGNAL state_4                          : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_1                            : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL state_5                          : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_2                            : std_logic;  -- ufix1
  SIGNAL dv_out                           : std_logic;  -- ufix1
  SIGNAL tmp_3                            : std_logic;
  SIGNAL dv_out_1                         : std_logic;  -- ufix1
  SIGNAL tmp_4                            : std_logic;  -- ufix1
  SIGNAL state_6                          : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_5                            : std_logic;  -- ufix1
  SIGNAL niters_1                         : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL tmp_6                            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL tmp_7                            : std_logic;
  SIGNAL tmp_8                            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL state_7                          : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_10                           : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL niters_2                         : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL tmp_11                           : std_logic;
  SIGNAL tmp_12                           : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL tmp_14                           : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL tmp_15                           : std_logic;
  SIGNAL tmp_16                           : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_18                           : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL state_8                          : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_19                           : std_logic;
  SIGNAL tmp_20                           : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_22                           : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL state_reg_state                  : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL dv_out_nr_2                      : std_logic;  -- ufix1
  SIGNAL tmp_24                           : std_logic;
  SIGNAL tmp_25                           : std_logic;  -- ufix1
  SIGNAL dv_out_nr_3                      : std_logic;  -- ufix1
  SIGNAL tmp_26                           : std_logic;
  SIGNAL tmp_27                           : std_logic;  -- ufix1
  SIGNAL tmp_29                           : std_logic;  -- ufix1
  SIGNAL tmp_30                           : std_logic;
  SIGNAL tmp_31                           : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_33                           : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL state_reg_state_1                : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL done                             : std_logic;  -- ufix1
  SIGNAL tmp_35                           : std_logic;  -- ufix1
  SIGNAL tmp_37                           : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL state_reg_state_2                : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL c                                : vector_of_signed18(0 TO 1);  -- sfix18_En12 [2]
  SIGNAL z_signed                         : vector_of_signed14(0 TO 1);  -- sfix14_En12 [2]
  SIGNAL c_1                              : vector_of_signed18(0 TO 1);  -- sfix18_En12 [2]
  SIGNAL c_2                              : vector_of_signed18(0 TO 5);  -- sfix18_En12 [6]
  SIGNAL c_3                              : vector_of_signed30(0 TO 5);  -- sfix30_En27 [6]
  SIGNAL c_4                              : vector_of_unsigned29(0 TO 11);  -- ufix29_En27 [12]
  SIGNAL tmp_38                           : std_logic;
  SIGNAL tmp_39                           : std_logic;
  SIGNAL tmp_40                           : std_logic;
  SIGNAL tmp_41                           : std_logic;
  SIGNAL tmp_42                           : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL tmp_43                           : std_logic;
  SIGNAL tmp_44                           : std_logic;
  SIGNAL tmp_45                           : std_logic;
  SIGNAL c_5                              : vector_of_unsigned18(0 TO 35);  -- ufix18_En5 [36]
  SIGNAL c_6                              : vector_of_unsigned22(0 TO 35);  -- ufix22_En5 [36]
  SIGNAL c_7                              : vector_of_unsigned16(0 TO 35);  -- ufix16_En15 [36]
  SIGNAL c_8                              : vector_of_unsigned33(0 TO 35);  -- ufix33_En19 [36]
  SIGNAL c_9                              : vector_of_unsigned18(0 TO 11);  -- ufix18_En4 [12]
  SIGNAL c_10                             : vector_of_unsigned22(0 TO 3);  -- ufix22_En4 [4]
  SIGNAL tmp_46                           : std_logic;
  SIGNAL c_11                             : vector_of_unsigned18(0 TO 11);  -- ufix18_En4 [12]
  SIGNAL p_prd                            : vector_of_unsigned14(0 TO 35);  -- ufix14_En4 [36]
  SIGNAL y                                : vector_of_unsigned14(0 TO 35);  -- ufix14_En4 [36]
  SIGNAL B                                : vector_of_unsigned14(0 TO 11);  -- ufix14_En4 [12]
  SIGNAL tmp_47                           : vector_of_unsigned14(0 TO 11);  -- ufix14_En4 [12]
  SIGNAL S                                : vector_of_unsigned14(0 TO 3);  -- ufix14_En3 [4]
  SIGNAL tmp_48                           : vector_of_unsigned14(0 TO 3);  -- ufix14_En3 [4]
  SIGNAL p117tmp_cast                     : signed(14 DOWNTO 0);  -- sfix15_En3
  SIGNAL p117tmp_cast_1                   : signed(15 DOWNTO 0);  -- sfix16_En3
  SIGNAL p117tmp_cast_2                   : signed(15 DOWNTO 0);  -- sfix16_En3
  SIGNAL p117tmp_cast_3                   : signed(14 DOWNTO 0);  -- sfix15_En3
  SIGNAL p117tmp_cast_4                   : signed(14 DOWNTO 0);  -- sfix15_En3
  SIGNAL p117tmp_cast_5                   : signed(15 DOWNTO 0);  -- sfix16_En3
  SIGNAL p117tmp_cast_6                   : signed(15 DOWNTO 0);  -- sfix16_En3
  SIGNAL p117tmp_cast_7                   : signed(14 DOWNTO 0);  -- sfix15_En3
  SIGNAL adjoint                          : vector_of_unsigned14(0 TO 3);  -- ufix14_En3 [4]
  SIGNAL tmp_49                           : vector_of_unsigned14(0 TO 3);  -- ufix14_En3 [4]
  SIGNAL xnew                             : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_50                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL p194tmp_cast                     : unsigned(15 DOWNTO 0);  -- ufix16_En14
  SIGNAL xnew_1                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL a_scale                          : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL tmp_51                           : std_logic;
  SIGNAL p193tmp_cast                     : unsigned(14 DOWNTO 0);  -- ufix15_En14
  SIGNAL tmp_52                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_53                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL p195tmp_cast                     : unsigned(16 DOWNTO 0);  -- ufix17_En14
  SIGNAL a                                : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL tmp_55                           : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL a_scale_1                        : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL tmp_56                           : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL tmp_58                           : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL tmp_59                           : std_logic;
  SIGNAL p190tmp_cast                     : unsigned(14 DOWNTO 0);  -- ufix15_En14
  SIGNAL tmp_60                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_61                           : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL p170tmp_cast                     : unsigned(16 DOWNTO 0);  -- ufix17_En13
  SIGNAL p_est                            : vector_of_unsigned14(0 TO 35);  -- ufix14_En5 [36]
  SIGNAL klm_gain                         : vector_of_unsigned14(0 TO 11);  -- ufix14_En15 [12]
  SIGNAL tmp_62                           : vector_of_unsigned14(0 TO 35);  -- ufix14_En5 [36]
  SIGNAL tmp_63                           : vector_of_unsigned14(0 TO 35);  -- ufix14_En4 [36]
  SIGNAL y_1                              : vector_of_unsigned14(0 TO 35);  -- ufix14_En4 [36]
  SIGNAL tmp_64                           : vector_of_unsigned14(0 TO 3);  -- ufix14_En3 [4]
  SIGNAL tmp_65                           : unsigned(13 DOWNTO 0);  -- ufix14_E8
  SIGNAL p116tmp_mul_temp                 : unsigned(27 DOWNTO 0);  -- ufix28_En6
  SIGNAL p116tmp_sub_cast                 : unsigned(28 DOWNTO 0);  -- ufix29_En6
  SIGNAL p116tmp_mul_temp_1               : unsigned(27 DOWNTO 0);  -- ufix28_En6
  SIGNAL p116tmp_sub_cast_1               : unsigned(28 DOWNTO 0);  -- ufix29_En6
  SIGNAL p116tmp_sub_temp                 : unsigned(28 DOWNTO 0);  -- ufix29_En6
  SIGNAL detS                             : unsigned(13 DOWNTO 0);  -- ufix14_E8
  SIGNAL tmp_67                           : unsigned(13 DOWNTO 0);  -- ufix14_E8
  SIGNAL p171a_cast                       : unsigned(27 DOWNTO 0);  -- ufix28_En26
  SIGNAL tmp_68                           : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL p169tmp_cast                     : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL a_1                              : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL tmp_70                           : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL a_2                              : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL tmp_71                           : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL tmp_73                           : unsigned(13 DOWNTO 0);  -- ufix14_En13
  SIGNAL xold                             : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_74                           : signed(13 DOWNTO 0);  -- sfix14_En14
  SIGNAL p186tmp_mul_temp                 : unsigned(27 DOWNTO 0);  -- ufix28_En27
  SIGNAL p186tmp_sub_cast                 : signed(29 DOWNTO 0);  -- sfix30_En27
  SIGNAL p186tmp_sub_temp                 : signed(29 DOWNTO 0);  -- sfix30_En27
  SIGNAL ek                               : signed(13 DOWNTO 0);  -- sfix14_En14
  SIGNAL ek_1                             : signed(13 DOWNTO 0);  -- sfix14_En14
  SIGNAL tmp_75                           : signed(13 DOWNTO 0);  -- sfix14_En14
  SIGNAL tmp_77                           : signed(13 DOWNTO 0);  -- sfix14_En14
  SIGNAL ek_2                             : signed(13 DOWNTO 0);  -- sfix14_En14
  SIGNAL tmp_78                           : signed(13 DOWNTO 0);  -- sfix14_En14
  SIGNAL tmp_80                           : signed(13 DOWNTO 0);  -- sfix14_En14
  SIGNAL tmp_82                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL xold_1                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_83                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_85                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_86                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL p187tmp_add_cast                 : signed(28 DOWNTO 0);  -- sfix29_En28
  SIGNAL p187tmp_cast                     : signed(14 DOWNTO 0);  -- sfix15_En14
  SIGNAL p187tmp_mul_temp                 : signed(28 DOWNTO 0);  -- sfix29_En28
  SIGNAL p187tmp_add_cast_1               : signed(27 DOWNTO 0);  -- sfix28_En28
  SIGNAL p187tmp_add_cast_2               : signed(28 DOWNTO 0);  -- sfix29_En28
  SIGNAL p187tmp_add_temp                 : signed(28 DOWNTO 0);  -- sfix29_En28
  SIGNAL tmp_87                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL xnew_2                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_88                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_90                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_91                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL xnew_3                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_92                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL reciprocal_detS                  : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL reciprocal_detS_1                : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_94                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_96                           : unsigned(13 DOWNTO 0);  -- ufix14_En14
  SIGNAL tmp_97                           : vector_of_unsigned14(0 TO 3);  -- ufix14_En23 [4]
  SIGNAL p196tmp_mul_temp                 : vector_of_unsigned28(0 TO 3);  -- ufix28_En17 [4]
  SIGNAL invS                             : vector_of_unsigned14(0 TO 3);  -- ufix14_En23 [4]
  SIGNAL tmp_98                           : vector_of_unsigned14(0 TO 3);  -- ufix14_En23 [4]
  SIGNAL S_backslash_B                    : vector_of_unsigned14(0 TO 11);  -- ufix14_En15 [12]
  SIGNAL tmp_99                           : vector_of_unsigned14(0 TO 11);  -- ufix14_En15 [12]
  SIGNAL tmp_101                          : vector_of_unsigned14(0 TO 11);  -- ufix14_En15 [12]
  SIGNAL x_prd                            : vector_of_signed14(0 TO 5);  -- sfix14_En12 [6]
  SIGNAL x_est                            : vector_of_signed14(0 TO 5);  -- sfix14_En12 [6]
  SIGNAL tmp_102                          : vector_of_signed14(0 TO 5);  -- sfix14_En12 [6]
  SIGNAL x_prd_reg_reg                    : vector_of_signed14(0 TO 5);  -- sfix14 [6]
  SIGNAL z_prd                            : vector_of_signed14(0 TO 1);  -- sfix14_En12 [2]
  SIGNAL tmp_103                          : vector_of_signed14(0 TO 1);  -- sfix14_En12 [2]
  SIGNAL z_prd_reg_reg                    : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL c_20                             : vector_of_signed15(0 TO 1);  -- sfix15_En12 [2]
  SIGNAL p198c_sub_cast                   : vector_of_signed15(0 TO 1);  -- sfix15_En12 [2]
  SIGNAL p198c_sub_cast_1                 : vector_of_signed15(0 TO 1);  -- sfix15_En12 [2]
  SIGNAL tmp_104                          : vector_of_signed14(0 TO 5);  -- sfix14_En12 [6]
  SIGNAL x_est_reg_reg                    : vector_of_signed14(0 TO 5);  -- sfix14 [6]
  SIGNAL tmp_105                          : vector_of_signed14(0 TO 1);  -- sfix14_En12 [2]
  SIGNAL y_reg_reg                        : vector_of_signed14(0 TO 1);  -- sfix14 [2]
  SIGNAL y_2                              : vector_of_signed14(0 TO 1);  -- sfix14_En12 [2]
  SIGNAL tmp_106                          : signed(31 DOWNTO 0);  -- int32
  SIGNAL tmp_107                          : signed(13 DOWNTO 0);  -- sfix14_En12
  SIGNAL tmp_108                          : signed(31 DOWNTO 0);  -- int32
  SIGNAL tmp_109                          : signed(13 DOWNTO 0);  -- sfix14_En12
  SIGNAL y2_1                             : signed(13 DOWNTO 0);  -- sfix14_En13
  SIGNAL tmp_110                          : std_logic;  -- ufix1
  SIGNAL dv_out_2                         : std_logic;  -- ufix1
  SIGNAL dv_out_q_1                       : std_logic;  -- ufix1

BEGIN
  dv_out_nr <= '0';

  niters <= to_unsigned(2#00#, 2);

  enb <= clk_enable;

  state <= to_unsigned(2#101#, 3);

  state_1 <= to_unsigned(2#011#, 3);

  state_2 <= to_unsigned(2#011#, 3);

  state_3 <= to_unsigned(2#010#, 3);

  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt
  
  tmp <= '1' WHEN dv_out_nr_1 = '1' ELSE
      '0';

  
  tmp_1 <= state_4 WHEN tmp = '0' ELSE
      state_2;

  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_falseregionp125
  state_5 <= tmp_1;

  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp138
  dv_out <= tmp_2;

  
  tmp_3 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  
  tmp_4 <= dv_out_1 WHEN tmp_3 = '0' ELSE
      dv_out;

  p93_output : PROCESS (state_6, tmp_4, dv_out_1, state_4)
    VARIABLE tmp1 : std_logic;
    VARIABLE tmp_0 : std_logic;
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_0 := dv_out_1;
      WHEN "010" =>
        tmp_0 := dv_out_1;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp1 := dv_out_1;
          WHEN "010" =>
            tmp1 := tmp_4;
          WHEN "011" =>
            tmp1 := dv_out_1;
          WHEN "100" =>
            tmp1 := dv_out_1;
          WHEN OTHERS => 
            tmp1 := dv_out_1;
        END CASE;

        tmp_0 := tmp1;
      WHEN "100" =>
        tmp_0 := dv_out_1;
      WHEN "101" =>
        tmp_0 := dv_out_1;
      WHEN OTHERS => 
        tmp_0 := dv_out_1;
    END CASE;

    tmp_5 <= tmp_0;
  END PROCESS p93_output;


  dv_out_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dv_out_1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        dv_out_1 <= tmp_5;
      END IF;
    END IF;
  END PROCESS dv_out_reg_process;

  tmp_6 <= niters_1 + to_unsigned(2#01#, 2);

  
  tmp_7 <= '1' WHEN niters_1 /= to_unsigned(2#11#, 2) ELSE
      '0';

  
  tmp_8 <= niters WHEN tmp_7 = '0' ELSE
      niters_1;

  p165_output : PROCESS (state_7, tmp_8, tmp_6, niters_1)
    VARIABLE tmp9 : unsigned(1 DOWNTO 0);
  BEGIN

    CASE state_7 IS
      WHEN "001" =>
        tmp9 := niters_1;
      WHEN "010" =>
        tmp9 := tmp_8;
      WHEN "011" =>
        tmp9 := niters_1;
      WHEN "100" =>
        tmp9 := tmp_6;
      WHEN "101" =>
        tmp9 := niters_1;
      WHEN "110" =>
        tmp9 := niters_1;
      WHEN OTHERS => 
        tmp9 := niters_1;
    END CASE;

    tmp_10 <= tmp9;
  END PROCESS p165_output;


  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp147
  niters_2 <= tmp_10;

  
  tmp_11 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  
  tmp_12 <= niters_1 WHEN tmp_11 = '0' ELSE
      niters_2;

  p102_output : PROCESS (state_6, tmp_12, niters_1, state_4)
    VARIABLE tmp13 : unsigned(1 DOWNTO 0);
    VARIABLE tmp_01 : unsigned(1 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_01 := niters_1;
      WHEN "010" =>
        tmp_01 := niters_1;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp13 := niters_1;
          WHEN "010" =>
            tmp13 := tmp_12;
          WHEN "011" =>
            tmp13 := niters_1;
          WHEN "100" =>
            tmp13 := niters_1;
          WHEN OTHERS => 
            tmp13 := niters_1;
        END CASE;

        tmp_01 := tmp13;
      WHEN "100" =>
        tmp_01 := niters_1;
      WHEN "101" =>
        tmp_01 := niters_1;
      WHEN OTHERS => 
        tmp_01 := niters_1;
    END CASE;

    tmp_14 <= tmp_01;
  END PROCESS p102_output;


  niters_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      niters_1 <= to_unsigned(2#00#, 2);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        niters_1 <= tmp_14;
      END IF;
    END IF;
  END PROCESS niters_reg_process;

  
  tmp_15 <= '1' WHEN niters_1 /= to_unsigned(2#11#, 2) ELSE
      '0';

  
  tmp_16 <= state WHEN tmp_15 = '0' ELSE
      state_1;

  p161_output : PROCESS (state_7, tmp_16)
    VARIABLE tmp17 : unsigned(2 DOWNTO 0);
  BEGIN

    CASE state_7 IS
      WHEN "001" =>
        tmp17 := to_unsigned(2#010#, 3);
      WHEN "010" =>
        tmp17 := tmp_16;
      WHEN "011" =>
        tmp17 := to_unsigned(2#100#, 3);
      WHEN "100" =>
        tmp17 := to_unsigned(2#010#, 3);
      WHEN "101" =>
        tmp17 := to_unsigned(2#110#, 3);
      WHEN "110" =>
        tmp17 := to_unsigned(2#001#, 3);
      WHEN OTHERS => 
        tmp17 := to_unsigned(2#000#, 3);
    END CASE;

    tmp_18 <= tmp17;
  END PROCESS p161_output;


  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp141
  state_8 <= tmp_18;

  
  tmp_19 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  
  tmp_20 <= state_7 WHEN tmp_19 = '0' ELSE
      state_8;

  p96_output : PROCESS (state_6, tmp_20, state_7, state_4)
    VARIABLE tmp21 : unsigned(2 DOWNTO 0);
    VARIABLE tmp_02 : unsigned(2 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_02 := state_7;
      WHEN "010" =>
        tmp_02 := state_7;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp21 := state_7;
          WHEN "010" =>
            tmp21 := tmp_20;
          WHEN "011" =>
            tmp21 := state_7;
          WHEN "100" =>
            tmp21 := state_7;
          WHEN OTHERS => 
            tmp21 := state_7;
        END CASE;

        tmp_02 := tmp21;
      WHEN "100" =>
        tmp_02 := state_7;
      WHEN "101" =>
        tmp_02 := state_7;
      WHEN OTHERS => 
        tmp_02 := state_7;
    END CASE;

    tmp_22 <= tmp_02;
  END PROCESS p96_output;


  state_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      state_reg_state <= to_unsigned(2#001#, 3);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        state_reg_state <= tmp_22;
      END IF;
    END IF;
  END PROCESS state_reg_process;
  state_7 <= state_reg_state;

  p159_output : PROCESS (state_7, dv_out_1)
    VARIABLE tmp23 : std_logic;
  BEGIN

    CASE state_7 IS
      WHEN "001" =>
        tmp23 := '0';
      WHEN "010" =>
        tmp23 := dv_out_1;
      WHEN "011" =>
        tmp23 := dv_out_1;
      WHEN "100" =>
        tmp23 := dv_out_1;
      WHEN "101" =>
        tmp23 := dv_out_1;
      WHEN "110" =>
        tmp23 := '1';
      WHEN OTHERS => 
        tmp23 := dv_out_1;
    END CASE;

    tmp_2 <= tmp23;
  END PROCESS p159_output;


  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp121
  dv_out_nr_2 <= tmp_2;

  
  tmp_24 <= '1' WHEN dv_out_nr_1 = '1' ELSE
      '0';

  
  tmp_25 <= dv_out_nr_1 WHEN tmp_24 = '0' ELSE
      dv_out_nr;

  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_falseregionp121
  dv_out_nr_3 <= tmp_25;

  
  tmp_26 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  
  tmp_27 <= dv_out_nr_3 WHEN tmp_26 = '0' ELSE
      dv_out_nr_2;

  p72_output : PROCESS (state_6, tmp_27, dv_out_nr_1, state_4)
    VARIABLE tmp28 : std_logic;
    VARIABLE tmp_03 : std_logic;
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_03 := dv_out_nr_1;
      WHEN "010" =>
        tmp_03 := dv_out_nr_1;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp28 := '0';
          WHEN "010" =>
            tmp28 := tmp_27;
          WHEN "011" =>
            tmp28 := dv_out_nr_1;
          WHEN "100" =>
            tmp28 := dv_out_nr_1;
          WHEN OTHERS => 
            tmp28 := dv_out_nr_1;
        END CASE;

        tmp_03 := tmp28;
      WHEN "100" =>
        tmp_03 := dv_out_nr_1;
      WHEN "101" =>
        tmp_03 := dv_out_nr_1;
      WHEN OTHERS => 
        tmp_03 := dv_out_nr_1;
    END CASE;

    tmp_29 <= tmp_03;
  END PROCESS p72_output;


  dv_out_nr_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dv_out_nr_1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        dv_out_nr_1 <= tmp_29;
      END IF;
    END IF;
  END PROCESS dv_out_nr_reg_process;

  
  tmp_30 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  
  tmp_31 <= state_5 WHEN tmp_30 = '0' ELSE
      state_3;

  p69_output : PROCESS (state_6, tmp_31, state_4)
    VARIABLE tmp32 : unsigned(2 DOWNTO 0);
    VARIABLE tmp_04 : unsigned(2 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_04 := state_4;
      WHEN "010" =>
        tmp_04 := state_4;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp32 := to_unsigned(2#010#, 3);
          WHEN "010" =>
            tmp32 := tmp_31;
          WHEN "011" =>
            tmp32 := to_unsigned(2#100#, 3);
          WHEN "100" =>
            tmp32 := to_unsigned(2#001#, 3);
          WHEN OTHERS => 
            tmp32 := to_unsigned(2#001#, 3);
        END CASE;

        tmp_04 := tmp32;
      WHEN "100" =>
        tmp_04 := state_4;
      WHEN "101" =>
        tmp_04 := state_4;
      WHEN OTHERS => 
        tmp_04 := state_4;
    END CASE;

    tmp_33 <= tmp_04;
  END PROCESS p69_output;


  state_reg_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      state_reg_state_1 <= to_unsigned(2#001#, 3);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        state_reg_state_1 <= tmp_33;
      END IF;
    END IF;
  END PROCESS state_reg_1_process;
  state_4 <= state_reg_state_1;

  p66_output : PROCESS (state_6, done, state_4)
    VARIABLE tmp34 : std_logic;
    VARIABLE tmp_05 : std_logic;
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_05 := done;
      WHEN "010" =>
        tmp_05 := done;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp34 := '0';
          WHEN "010" =>
            tmp34 := done;
          WHEN "011" =>
            tmp34 := done;
          WHEN "100" =>
            tmp34 := '1';
          WHEN OTHERS => 
            tmp34 := done;
        END CASE;

        tmp_05 := tmp34;
      WHEN "100" =>
        tmp_05 := done;
      WHEN "101" =>
        tmp_05 := done;
      WHEN OTHERS => 
        tmp_05 := done;
    END CASE;

    tmp_35 <= tmp_05;
  END PROCESS p66_output;


  done_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      done <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        done <= tmp_35;
      END IF;
    END IF;
  END PROCESS done_reg_process;

  p36_output : PROCESS (state_6, done, state_4)
    VARIABLE tmp36 : std_logic;
    VARIABLE tmp_06 : unsigned(2 DOWNTO 0);
    VARIABLE tmp_13 : unsigned(2 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_13 := to_unsigned(2#010#, 3);
      WHEN "010" =>
        tmp_13 := to_unsigned(2#011#, 3);
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp36 := '0';
          WHEN "010" =>
            tmp36 := done;
          WHEN "011" =>
            tmp36 := done;
          WHEN "100" =>
            tmp36 := '1';
          WHEN OTHERS => 
            tmp36 := done;
        END CASE;

        IF tmp36 = '0' THEN 
          tmp_06 := to_unsigned(2#011#, 3);
        ELSE 
          tmp_06 := to_unsigned(2#100#, 3);
        END IF;
        tmp_13 := tmp_06;
      WHEN "100" =>
        tmp_13 := to_unsigned(2#101#, 3);
      WHEN "101" =>
        tmp_13 := to_unsigned(2#001#, 3);
      WHEN OTHERS => 
        tmp_13 := to_unsigned(2#001#, 3);
    END CASE;

    tmp_37 <= tmp_13;
  END PROCESS p36_output;


  state_reg_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      state_reg_state_2 <= to_unsigned(2#001#, 3);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        state_reg_state_2 <= tmp_37;
      END IF;
    END IF;
  END PROCESS state_reg_2_process;
  state_6 <= state_reg_state_2;

  c <= (OTHERS => to_signed(2#000000000000000000#, 18));

  outputgen: FOR k10 IN 0 TO 1 GENERATE
    z_signed(k10) <= signed(z(k10));
  END GENERATE;

  c_1 <= (OTHERS => to_signed(2#000000000000000000#, 18));

  c_2 <= (OTHERS => to_signed(2#000000000000000000#, 18));

  c_3 <= (OTHERS => to_signed(2#000000000000000000000000000000#, 30));

  c_4 <= (OTHERS => to_unsigned(2#00000000000000000000000000000#, 29));

  
  tmp_38 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  
  tmp_39 <= '1' WHEN niters_1 /= to_unsigned(2#11#, 2) ELSE
      '0';

  
  tmp_40 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  
  tmp_41 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';
 




  tmp_42 <= state_6;

  
  tmp_43 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  
  tmp_44 <= '1' WHEN niters_1 /= to_unsigned(2#11#, 2) ELSE
      '0';

  
  tmp_45 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  c_5 <= (OTHERS => to_unsigned(2#000000000000000000#, 18));

  c_6 <= (OTHERS => to_unsigned(2#0000000000000000000000#, 22));

  c_7 <= (OTHERS => to_unsigned(16#0000#, 16));

  c_8 <= (OTHERS => to_unsigned(0, 33));

  c_9 <= (OTHERS => to_unsigned(2#000000000000000000#, 18));

  c_10 <= (OTHERS => to_unsigned(2#0000000000000000000000#, 22));

  
  tmp_46 <= '1' WHEN dv_out_nr_1 = '0' ELSE
      '0';

  c_11 <= (OTHERS => to_unsigned(2#000000000000000000#, 18));

  p114y_output : PROCESS (p_prd)
  BEGIN

    FOR t_1 IN 0 TO 5 LOOP
      FOR t_0 IN 0 TO 5 LOOP
        y(t_0 + (6 * t_1)) <= p_prd(t_1 + (6 * t_0));
      END LOOP;
    END LOOP;

  END PROCESS p114y_output;


  p45_output : PROCESS (state_6, y, c_11, B)
    VARIABLE c12 : vector_of_unsigned18(0 TO 11);
    VARIABLE add_cast : vector_of_signed64(0 TO 5);
    VARIABLE add_cast_0 : vector_of_signed64(0 TO 5);
    VARIABLE add_cast_1 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_cast_2 : vector_of_signed64(0 TO 5);
    VARIABLE t_11 : vector_of_unsigned14(0 TO 5);
    VARIABLE add_cast_3 : vector_of_unsigned15(0 TO 5);
    VARIABLE add_cast_4 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_temp : vector_of_unsigned19(0 TO 5);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_47 <= B;
      WHEN "010" =>
        c12 := c_11;

        FOR l IN 0 TO 1 LOOP
          FOR m IN 0 TO 5 LOOP
            FOR k IN 0 TO 5 LOOP
              add_cast(k) := resize(to_signed(m, 32) & '0', 64);
              add_cast_0(k) := resize(to_signed(m, 32) & '0', 64);
              add_cast_1(k) := resize(c12(to_integer(to_signed(l, 32) + resize(add_cast_0(k), 32))), 19);
              add_cast_2(k) := resize(to_signed(k, 32) & '0', 64);
              IF a_3(to_integer(to_signed(l, 32) + resize(add_cast_2(k), 32))) = '1' THEN 
                t_11(k) := y(k + (6 * m));
              ELSE 
                t_11(k) := to_unsigned(2#00000000000000#, 14);
              END IF;
              add_cast_3(k) := resize(t_11(k), 15);
              add_cast_4(k) := resize(add_cast_3(k), 19);
              add_temp(k) := add_cast_1(k) + add_cast_4(k);
              c12(to_integer(to_signed(l, 32) + resize(add_cast(k), 32))) := add_temp(k)(17 DOWNTO 0);
            END LOOP;
          END LOOP;
        END LOOP;


        FOR t_01 IN 0 TO 11 LOOP
          tmp_47(t_01) <= c12(t_01)(13 DOWNTO 0);
        END LOOP;

      WHEN "011" =>
        tmp_47 <= B;
      WHEN "100" =>
        tmp_47 <= B;
      WHEN "101" =>
        tmp_47 <= B;
      WHEN OTHERS => 
        tmp_47 <= B;
    END CASE;

  END PROCESS p45_output;


  B_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      B <= (OTHERS => to_unsigned(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        B <= tmp_47;
      END IF;
    END IF;
  END PROCESS B_reg_process;

  -- abs is the algorithm, but not needed with the valuse in this example
  --        reciprocal_detS = 1/detS;
  --transposed cofactor
  tmp_48(0) <= S(3);
  p117tmp_cast <= signed(resize(S(2), 15));
  p117tmp_cast_1 <= resize(p117tmp_cast, 16);
  p117tmp_cast_2 <=  - (p117tmp_cast_1);
  p117tmp_cast_3 <= p117tmp_cast_2(14 DOWNTO 0);
  tmp_48(2) <= unsigned(p117tmp_cast_3(13 DOWNTO 0));
  p117tmp_cast_4 <= signed(resize(S(1), 15));
  p117tmp_cast_5 <= resize(p117tmp_cast_4, 16);
  p117tmp_cast_6 <=  - (p117tmp_cast_5);
  p117tmp_cast_7 <= p117tmp_cast_6(14 DOWNTO 0);
  tmp_48(1) <= unsigned(p117tmp_cast_7(13 DOWNTO 0));
  tmp_48(3) <= S(0);

  p63_output : PROCESS (state_6, tmp_48, adjoint, state_4)
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_49 <= adjoint;
      WHEN "010" =>
        tmp_49 <= adjoint;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp_49 <= tmp_48;
          WHEN "010" =>
            tmp_49 <= adjoint;
          WHEN "011" =>
            tmp_49 <= adjoint;
          WHEN "100" =>
            tmp_49 <= adjoint;
          WHEN OTHERS => 
            tmp_49 <= adjoint;
        END CASE;

      WHEN "100" =>
        tmp_49 <= adjoint;
      WHEN "101" =>
        tmp_49 <= adjoint;
      WHEN OTHERS => 
        tmp_49 <= adjoint;
    END CASE;

  END PROCESS p63_output;


  adjoint_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      adjoint <= (OTHERS => to_unsigned(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        adjoint <= tmp_49;
      END IF;
    END IF;
  END PROCESS adjoint_reg_process;

  p194tmp_cast <= resize(xnew & '0', 16);
  tmp_50 <= p194tmp_cast(13 DOWNTO 0);

  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp191
  xnew_1 <= tmp_50;

  p193tmp_cast <= a_scale & '0';
  
  tmp_51 <= '1' WHEN (p193tmp_cast >= to_unsigned(2#010000000000000#, 15)) AND (a_scale < to_unsigned(2#10000000000000#, 14)) ELSE
      '0';

  
  tmp_52 <= xnew WHEN tmp_51 = '0' ELSE
      xnew_1;

  --        state = 3;
  --invdetM = 1/detM;  %transposed cofactor below
  p195tmp_cast <= resize(xnew & '0' & '0', 17);
  tmp_53 <= p195tmp_cast(13 DOWNTO 0);

  p157_output : PROCESS (state_7, a, a_scale)
    VARIABLE tmp54 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_7 IS
      WHEN "001" =>
        tmp54 := a;
      WHEN "010" =>
        tmp54 := a_scale;
      WHEN "011" =>
        tmp54 := a_scale;
      WHEN "100" =>
        tmp54 := a_scale;
      WHEN "101" =>
        tmp54 := a_scale;
      WHEN "110" =>
        tmp54 := a_scale;
      WHEN OTHERS => 
        tmp54 := a_scale;
    END CASE;

    tmp_55 <= tmp54;
  END PROCESS p157_output;


  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp135
  a_scale_1 <= tmp_55;

  
  tmp_56 <= a_scale WHEN tmp_46 = '0' ELSE
      a_scale_1;

  p90_output : PROCESS (state_6, tmp_56, a_scale, state_4)
    VARIABLE tmp57 : unsigned(13 DOWNTO 0);
    VARIABLE tmp_07 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_07 := a_scale;
      WHEN "010" =>
        tmp_07 := a_scale;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp57 := a_scale;
          WHEN "010" =>
            tmp57 := tmp_56;
          WHEN "011" =>
            tmp57 := a_scale;
          WHEN "100" =>
            tmp57 := a_scale;
          WHEN OTHERS => 
            tmp57 := a_scale;
        END CASE;

        tmp_07 := tmp57;
      WHEN "100" =>
        tmp_07 := a_scale;
      WHEN "101" =>
        tmp_07 := a_scale;
      WHEN OTHERS => 
        tmp_07 := a_scale;
    END CASE;

    tmp_58 <= tmp_07;
  END PROCESS p90_output;


  a_scale_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      a_scale <= to_unsigned(2#00000000000000#, 14);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        a_scale <= tmp_58;
      END IF;
    END IF;
  END PROCESS a_scale_reg_process;

  p190tmp_cast <= a_scale & '0';
  
  tmp_59 <= '1' WHEN p190tmp_cast < to_unsigned(2#010000000000000#, 15) ELSE
      '0';

  
  tmp_60 <= tmp_53 WHEN tmp_59 = '0' ELSE
      tmp_52;

  p170tmp_cast <= resize(a & '0' & '0', 17);
  tmp_61 <= p170tmp_cast(13 DOWNTO 0);

  p54_output : PROCESS (state_6, c_7, c_8, p_est, klm_gain, p_prd)
    VARIABLE c13 : vector_of_unsigned16(0 TO 35);
    VARIABLE c_0 : vector_of_unsigned33(0 TO 35);
    VARIABLE add_cast1 : vector_of_unsigned17(0 TO 1);
    VARIABLE add_cast_01 : vector_of_signed64(0 TO 1);
    VARIABLE t_12 : vector_of_unsigned14(0 TO 1);
    VARIABLE add_cast_11 : vector_of_unsigned15(0 TO 1);
    VARIABLE add_cast_21 : vector_of_unsigned17(0 TO 1);
    VARIABLE add_temp1 : vector_of_unsigned17(0 TO 1);
    VARIABLE sub_cast : vector_of_unsigned34(0 TO 35);
    VARIABLE sub_cast_0 : vector_of_unsigned34(0 TO 35);
    VARIABLE sub_temp : vector_of_unsigned34(0 TO 35);
    VARIABLE add_cast_31 : vector_of_unsigned34(0 TO 5);
    VARIABLE mul_temp : vector_of_unsigned30(0 TO 5);
    VARIABLE add_cast_41 : vector_of_unsigned34(0 TO 5);
    VARIABLE add_temp_0 : vector_of_unsigned34(0 TO 5);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_62 <= p_est;
      WHEN "010" =>
        tmp_62 <= p_est;
      WHEN "011" =>
        tmp_62 <= p_est;
      WHEN "100" =>
        c13 := c_7;

        FOR l1 IN 0 TO 5 LOOP
          FOR m1 IN 0 TO 5 LOOP
            FOR k1 IN 0 TO 1 LOOP
              add_cast1(k1) := resize(c13(l1 + (6 * m1)), 17);
              add_cast_01(k1) := resize(to_signed(m1, 32) & '0', 64);
              IF a_5(to_integer(to_signed(k1, 32) + resize(add_cast_01(k1), 32))) = '1' THEN 
                t_12(k1) := klm_gain(l1 + (6 * k1));
              ELSE 
                t_12(k1) := to_unsigned(2#00000000000000#, 14);
              END IF;
              add_cast_11(k1) := resize(t_12(k1), 15);
              add_cast_21(k1) := resize(add_cast_11(k1), 17);
              add_temp1(k1) := add_cast1(k1) + add_cast_21(k1);
              c13(l1 + (6 * m1)) := add_temp1(k1)(15 DOWNTO 0);
            END LOOP;
          END LOOP;
        END LOOP;

        c_0 := c_8;

        FOR l_0 IN 0 TO 5 LOOP
          FOR m_0 IN 0 TO 5 LOOP
            FOR k_0 IN 0 TO 5 LOOP
              add_cast_31(k_0) := resize(c_0(l_0 + (6 * m_0)), 34);
              mul_temp(k_0) := c13(l_0 + (6 * k_0)) * p_prd(k_0 + (6 * m_0));
              add_cast_41(k_0) := resize(mul_temp(k_0), 34);
              add_temp_0(k_0) := add_cast_31(k_0) + add_cast_41(k_0);
              c_0(l_0 + (6 * m_0)) := add_temp_0(k_0)(32 DOWNTO 0);
            END LOOP;
          END LOOP;
        END LOOP;


        FOR t_02 IN 0 TO 35 LOOP
          sub_cast(t_02) := resize(p_prd(t_02) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 34);
          sub_cast_0(t_02) := resize(c_0(t_02), 34);
          sub_temp(t_02) := sub_cast(t_02) - sub_cast_0(t_02);
          tmp_62(t_02) <= sub_temp(t_02)(27 DOWNTO 14);
        END LOOP;

      WHEN "101" =>
        tmp_62 <= p_est;
      WHEN OTHERS => 
        tmp_62 <= p_est;
    END CASE;

  END PROCESS p54_output;


  p_est_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      p_est <= (OTHERS => to_unsigned(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        p_est <= tmp_62;
      END IF;
    END IF;
  END PROCESS p_est_reg_process;

  p30_output : PROCESS (state_6, c_5, c_6, p_prd, p_est)
    VARIABLE c14 : vector_of_unsigned18(0 TO 35);
    VARIABLE c_01 : vector_of_unsigned22(0 TO 35);
    VARIABLE add_cast2 : vector_of_unsigned19(0 TO 5);
    VARIABLE t_13 : vector_of_unsigned14(0 TO 5);
    VARIABLE add_cast_02 : vector_of_unsigned15(0 TO 5);
    VARIABLE add_cast_12 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_temp2 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_cast_22 : vector_of_unsigned23(0 TO 35);
    VARIABLE add_temp_01 : vector_of_unsigned23(0 TO 35);
    VARIABLE add_cast_32 : vector_of_unsigned23(0 TO 5);
    VARIABLE t_2 : vector_of_unsigned18(0 TO 5);
    VARIABLE add_cast_42 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_cast_5 : vector_of_unsigned23(0 TO 5);
    VARIABLE add_temp_1 : vector_of_unsigned23(0 TO 5);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        c14 := c_5;

        FOR l2 IN 0 TO 5 LOOP
          FOR m2 IN 0 TO 5 LOOP
            FOR k2 IN 0 TO 5 LOOP
              add_cast2(k2) := resize(c14(l2 + (6 * m2)), 19);
              IF a0(l2 + (6 * k2)) = '1' THEN 
                t_13(k2) := p_est(k2 + (6 * m2));
              ELSE 
                t_13(k2) := to_unsigned(2#00000000000000#, 14);
              END IF;
              add_cast_02(k2) := resize(t_13(k2), 15);
              add_cast_12(k2) := resize(add_cast_02(k2), 19);
              add_temp2(k2) := add_cast2(k2) + add_cast_12(k2);
              c14(l2 + (6 * m2)) := add_temp2(k2)(17 DOWNTO 0);
            END LOOP;
          END LOOP;
        END LOOP;

        c_01 := c_6;

        FOR l_01 IN 0 TO 5 LOOP
          FOR m_01 IN 0 TO 5 LOOP
            FOR k_01 IN 0 TO 5 LOOP
              add_cast_32(k_01) := resize(c_01(l_01 + (6 * m_01)), 23);
              IF b0(k_01 + (6 * m_01)) = '1' THEN 
                t_2(k_01) := c14(l_01 + (6 * k_01));
              ELSE 
                t_2(k_01) := to_unsigned(2#000000000000000000#, 18);
              END IF;
              add_cast_42(k_01) := resize(t_2(k_01), 19);
              add_cast_5(k_01) := resize(add_cast_42(k_01), 23);
              add_temp_1(k_01) := add_cast_32(k_01) + add_cast_5(k_01);
              c_01(l_01 + (6 * m_01)) := add_temp_1(k_01)(21 DOWNTO 0);
            END LOOP;
          END LOOP;
        END LOOP;


        FOR t_03 IN 0 TO 35 LOOP
          add_cast_22(t_03) := resize(c_01(t_03), 23);
          add_temp_01(t_03) := add_cast_22(t_03) + nc(t_03);
          tmp_63(t_03) <= add_temp_01(t_03)(14 DOWNTO 1);
        END LOOP;

      WHEN "010" =>
        tmp_63 <= p_prd;
      WHEN "011" =>
        tmp_63 <= p_prd;
      WHEN "100" =>
        tmp_63 <= p_prd;
      WHEN "101" =>
        tmp_63 <= p_prd;
      WHEN OTHERS => 
        tmp_63 <= p_prd;
    END CASE;

  END PROCESS p30_output;


  p_prd_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      p_prd <= (OTHERS => to_unsigned(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        p_prd <= tmp_63;
      END IF;
    END IF;
  END PROCESS p_prd_reg_process;

  p111y_output : PROCESS (p_prd)
  BEGIN

    FOR t_14 IN 0 TO 5 LOOP
      FOR t_04 IN 0 TO 5 LOOP
        y_1(t_04 + (6 * t_14)) <= p_prd(t_14 + (6 * t_04));
      END LOOP;
    END LOOP;

  END PROCESS p111y_output;


  p42_output : PROCESS (state_6, y_1, c_9, c_10, S)
    VARIABLE c15 : vector_of_unsigned18(0 TO 11);
    VARIABLE c_02 : vector_of_unsigned22(0 TO 3);
    VARIABLE add_cast3 : vector_of_signed64(0 TO 5);
    VARIABLE add_cast_03 : vector_of_signed64(0 TO 5);
    VARIABLE add_cast_13 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_cast_23 : vector_of_signed64(0 TO 5);
    VARIABLE t_15 : vector_of_unsigned14(0 TO 5);
    VARIABLE add_cast_33 : vector_of_unsigned15(0 TO 5);
    VARIABLE add_cast_43 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_temp3 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_cast_51 : vector_of_unsigned23(0 TO 3);
    VARIABLE add_temp_02 : vector_of_unsigned23(0 TO 3);
    VARIABLE add_cast_6 : vector_of_signed64(0 TO 5);
    VARIABLE add_cast_7 : vector_of_signed64(0 TO 5);
    VARIABLE add_cast_8 : vector_of_unsigned23(0 TO 5);
    VARIABLE add_cast_9 : vector_of_signed64(0 TO 5);
    VARIABLE t_21 : vector_of_unsigned18(0 TO 5);
    VARIABLE add_cast_10 : vector_of_unsigned19(0 TO 5);
    VARIABLE add_cast_111 : vector_of_unsigned23(0 TO 5);
    VARIABLE add_temp_11 : vector_of_unsigned23(0 TO 5);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_64 <= S;
      WHEN "010" =>
        c15 := c_9;

        FOR l3 IN 0 TO 1 LOOP
          FOR m3 IN 0 TO 5 LOOP
            FOR k3 IN 0 TO 5 LOOP
              add_cast3(k3) := resize(to_signed(m3, 32) & '0', 64);
              add_cast_03(k3) := resize(to_signed(m3, 32) & '0', 64);
              add_cast_13(k3) := resize(c15(to_integer(to_signed(l3, 32) + resize(add_cast_03(k3), 32))), 19);
              add_cast_23(k3) := resize(to_signed(k3, 32) & '0', 64);
              IF a_7(to_integer(to_signed(l3, 32) + resize(add_cast_23(k3), 32))) = '1' THEN 
                t_15(k3) := y_1(k3 + (6 * m3));
              ELSE 
                t_15(k3) := to_unsigned(2#00000000000000#, 14);
              END IF;
              add_cast_33(k3) := resize(t_15(k3), 15);
              add_cast_43(k3) := resize(add_cast_33(k3), 19);
              add_temp3(k3) := add_cast_13(k3) + add_cast_43(k3);
              c15(to_integer(to_signed(l3, 32) + resize(add_cast3(k3), 32))) := add_temp3(k3)(17 DOWNTO 0);
            END LOOP;
          END LOOP;
        END LOOP;

        c_02 := c_10;

        FOR l_02 IN 0 TO 1 LOOP
          FOR m_02 IN 0 TO 1 LOOP
            FOR k_02 IN 0 TO 5 LOOP
              add_cast_6(k_02) := resize(to_signed(m_02, 32) & '0', 64);
              add_cast_7(k_02) := resize(to_signed(m_02, 32) & '0', 64);
              add_cast_8(k_02) := resize(c_02(to_integer(to_signed(l_02, 32) + resize(add_cast_7(k_02), 32))), 23);
              add_cast_9(k_02) := resize(to_signed(k_02, 32) & '0', 64);
              IF b0_2(k_02 + (6 * m_02)) = '1' THEN 
                t_21(k_02) := c15(to_integer(to_signed(l_02, 32) + resize(add_cast_9(k_02), 32)));
              ELSE 
                t_21(k_02) := to_unsigned(2#000000000000000000#, 18);
              END IF;
              add_cast_10(k_02) := resize(t_21(k_02), 19);
              add_cast_111(k_02) := resize(add_cast_10(k_02), 23);
              add_temp_11(k_02) := add_cast_8(k_02) + add_cast_111(k_02);
              c_02(to_integer(to_signed(l_02, 32) + resize(add_cast_6(k_02), 32))) := add_temp_11(k_02)(21 DOWNTO 0);
            END LOOP;
          END LOOP;
        END LOOP;


        FOR t_05 IN 0 TO 3 LOOP
          add_cast_51(t_05) := resize(c_02(t_05), 23);
          add_temp_02(t_05) := add_cast_51(t_05) + nc_2(t_05);
          tmp_64(t_05) <= add_temp_02(t_05)(14 DOWNTO 1);
        END LOOP;

      WHEN "011" =>
        tmp_64 <= S;
      WHEN "100" =>
        tmp_64 <= S;
      WHEN "101" =>
        tmp_64 <= S;
      WHEN OTHERS => 
        tmp_64 <= S;
    END CASE;

  END PROCESS p42_output;


  S_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      S <= (OTHERS => to_unsigned(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        S <= tmp_64;
      END IF;
    END IF;
  END PROCESS S_reg_process;

  p116tmp_mul_temp <= S(0) * S(3);
  p116tmp_sub_cast <= resize(p116tmp_mul_temp, 29);
  p116tmp_mul_temp_1 <= S(2) * S(1);
  p116tmp_sub_cast_1 <= resize(p116tmp_mul_temp_1, 29);
  p116tmp_sub_temp <= p116tmp_sub_cast - p116tmp_sub_cast_1;
  tmp_65 <= p116tmp_sub_temp(27 DOWNTO 14);

  p60_output : PROCESS (state_6, tmp_65, detS, state_4)
    VARIABLE tmp66 : unsigned(13 DOWNTO 0);
    VARIABLE tmp_08 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_08 := detS;
      WHEN "010" =>
        tmp_08 := detS;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp66 := tmp_65;
          WHEN "010" =>
            tmp66 := detS;
          WHEN "011" =>
            tmp66 := detS;
          WHEN "100" =>
            tmp66 := detS;
          WHEN OTHERS => 
            tmp66 := detS;
        END CASE;

        tmp_08 := tmp66;
      WHEN "100" =>
        tmp_08 := detS;
      WHEN "101" =>
        tmp_08 := detS;
      WHEN OTHERS => 
        tmp_08 := detS;
    END CASE;

    tmp_67 <= tmp_08;
  END PROCESS p60_output;


  detS_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      detS <= to_unsigned(2#00000000000000#, 14);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        detS <= tmp_67;
      END IF;
    END IF;
  END PROCESS detS_reg_process;

  -- B3
  -- normalize with 1/2^21
  p171a_cast <= resize(detS & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 28);
  a <= p171a_cast(26 DOWNTO 13);

  p169tmp_cast <= resize(a & '0', 16);
  tmp_68 <= p169tmp_cast(13 DOWNTO 0);

  p153_output : PROCESS (state_7, tmp_68, a, tmp_61, a_1)
    VARIABLE tmp69 : unsigned(13 DOWNTO 0);
    VARIABLE tmp_09 : unsigned(13 DOWNTO 0);
    VARIABLE tmp_17 : unsigned(13 DOWNTO 0);
    VARIABLE cast : unsigned(14 DOWNTO 0);
    VARIABLE cast_0 : unsigned(14 DOWNTO 0);
  BEGIN

    CASE state_7 IS
      WHEN "001" =>
        cast := a & '0';
        IF (cast >= to_unsigned(2#010000000000000#, 15)) AND (a < to_unsigned(2#10000000000000#, 14)) THEN 
          tmp69 := tmp_68;
        ELSE 
          tmp69 := a;
        END IF;
        cast_0 := a & '0';
        IF cast_0 < to_unsigned(2#010000000000000#, 15) THEN 
          tmp_09 := tmp69;
        ELSE 
          tmp_09 := tmp_61;
        END IF;
        tmp_17 := tmp_09;
      WHEN "010" =>
        tmp_17 := a_1;
      WHEN "011" =>
        tmp_17 := a_1;
      WHEN "100" =>
        tmp_17 := a_1;
      WHEN "101" =>
        tmp_17 := a_1;
      WHEN "110" =>
        tmp_17 := a_1;
      WHEN OTHERS => 
        tmp_17 := a_1;
    END CASE;

    tmp_70 <= tmp_17;
  END PROCESS p153_output;


  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp129
  a_2 <= tmp_70;

  
  tmp_71 <= a_1 WHEN tmp_45 = '0' ELSE
      a_2;

  p84_output : PROCESS (state_6, tmp_71, a_1, state_4)
    VARIABLE tmp72 : unsigned(13 DOWNTO 0);
    VARIABLE tmp_010 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_010 := a_1;
      WHEN "010" =>
        tmp_010 := a_1;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp72 := a_1;
          WHEN "010" =>
            tmp72 := tmp_71;
          WHEN "011" =>
            tmp72 := a_1;
          WHEN "100" =>
            tmp72 := a_1;
          WHEN OTHERS => 
            tmp72 := a_1;
        END CASE;

        tmp_010 := tmp72;
      WHEN "100" =>
        tmp_010 := a_1;
      WHEN "101" =>
        tmp_010 := a_1;
      WHEN OTHERS => 
        tmp_010 := a_1;
    END CASE;

    tmp_73 <= tmp_010;
  END PROCESS p84_output;


  a_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      a_1 <= to_unsigned(2#00000000000000#, 14);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        a_1 <= tmp_73;
      END IF;
    END IF;
  END PROCESS a_reg_process;

  p186tmp_mul_temp <= a_1 * xold;
  p186tmp_sub_cast <= signed(resize(p186tmp_mul_temp, 30));
  p186tmp_sub_temp <= to_signed(2#001000000000000000000000000000#, 30) - p186tmp_sub_cast;
  tmp_74 <= p186tmp_sub_temp(26 DOWNTO 13);

  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp172
  ek <= tmp_74;

  
  tmp_75 <= ek_1 WHEN tmp_44 = '0' ELSE
      ek;

  p167_output : PROCESS (state_7, tmp_75, ek_1)
    VARIABLE tmp76 : signed(13 DOWNTO 0);
  BEGIN

    CASE state_7 IS
      WHEN "001" =>
        tmp76 := ek_1;
      WHEN "010" =>
        tmp76 := tmp_75;
      WHEN "011" =>
        tmp76 := ek_1;
      WHEN "100" =>
        tmp76 := ek_1;
      WHEN "101" =>
        tmp76 := ek_1;
      WHEN "110" =>
        tmp76 := ek_1;
      WHEN OTHERS => 
        tmp76 := ek_1;
    END CASE;

    tmp_77 <= tmp76;
  END PROCESS p167_output;


  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp150
  ek_2 <= tmp_77;

  
  tmp_78 <= ek_1 WHEN tmp_43 = '0' ELSE
      ek_2;

  p105_output : PROCESS (tmp_42, tmp_78, ek_1, state_4)
    VARIABLE tmp79 : signed(13 DOWNTO 0);
    VARIABLE tmp_011 : signed(13 DOWNTO 0);
  BEGIN

    CASE tmp_42 IS
      WHEN "001" =>
        tmp_011 := ek_1;
      WHEN "010" =>
        tmp_011 := ek_1;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp79 := ek_1;
          WHEN "010" =>
            tmp79 := tmp_78;
          WHEN "011" =>
            tmp79 := ek_1;
          WHEN "100" =>
            tmp79 := ek_1;
          WHEN OTHERS => 
            tmp79 := ek_1;
        END CASE;

        tmp_011 := tmp79;
      WHEN "100" =>
        tmp_011 := ek_1;
      WHEN "101" =>
        tmp_011 := ek_1;
      WHEN OTHERS => 
        tmp_011 := ek_1;
    END CASE;

    tmp_80 <= tmp_011;
  END PROCESS p105_output;


  ek_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      ek_1 <= to_signed(2#00000000000000#, 14);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        ek_1 <= tmp_80;
      END IF;
    END IF;
  END PROCESS ek_reg_process;

  p155_output : PROCESS (state_7, xnew, xold)
    VARIABLE tmp81 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_7 IS
      WHEN "001" =>
        tmp81 := to_unsigned(2#10101101001010#, 14);
      WHEN "010" =>
        tmp81 := xold;
      WHEN "011" =>
        tmp81 := xold;
      WHEN "100" =>
        tmp81 := xnew;
      WHEN "101" =>
        tmp81 := xold;
      WHEN "110" =>
        tmp81 := xold;
      WHEN OTHERS => 
        tmp81 := xold;
    END CASE;

    tmp_82 <= tmp81;
  END PROCESS p155_output;


  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp132
  xold_1 <= tmp_82;

  
  tmp_83 <= xold WHEN tmp_41 = '0' ELSE
      xold_1;

  p87_output : PROCESS (state_6, tmp_83, xold, state_4)
    VARIABLE tmp84 : unsigned(13 DOWNTO 0);
    VARIABLE tmp_012 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_012 := xold;
      WHEN "010" =>
        tmp_012 := xold;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp84 := xold;
          WHEN "010" =>
            tmp84 := tmp_83;
          WHEN "011" =>
            tmp84 := xold;
          WHEN "100" =>
            tmp84 := xold;
          WHEN OTHERS => 
            tmp84 := xold;
        END CASE;

        tmp_012 := tmp84;
      WHEN "100" =>
        tmp_012 := xold;
      WHEN "101" =>
        tmp_012 := xold;
      WHEN OTHERS => 
        tmp_012 := xold;
    END CASE;

    tmp_85 <= tmp_012;
  END PROCESS p87_output;


  xold_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      xold <= to_unsigned(2#00000000000000#, 14);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        xold <= tmp_85;
      END IF;
    END IF;
  END PROCESS xold_reg_process;

  p187tmp_add_cast <= signed(resize(xold & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 29));
  p187tmp_cast <= signed(resize(xold, 15));
  p187tmp_mul_temp <= ek_1 * p187tmp_cast;
  p187tmp_add_cast_1 <= p187tmp_mul_temp(27 DOWNTO 0);
  p187tmp_add_cast_2 <= resize(p187tmp_add_cast_1, 29);
  p187tmp_add_temp <= p187tmp_add_cast + p187tmp_add_cast_2;
  tmp_86 <= unsigned(p187tmp_add_temp(27 DOWNTO 14));

  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp144
  xnew_2 <= tmp_87;

  
  tmp_88 <= xnew WHEN tmp_40 = '0' ELSE
      xnew_2;

  p99_output : PROCESS (state_6, tmp_88, xnew, state_4)
    VARIABLE tmp89 : unsigned(13 DOWNTO 0);
    VARIABLE tmp_013 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_013 := xnew;
      WHEN "010" =>
        tmp_013 := xnew;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp89 := xnew;
          WHEN "010" =>
            tmp89 := tmp_88;
          WHEN "011" =>
            tmp89 := xnew;
          WHEN "100" =>
            tmp89 := xnew;
          WHEN OTHERS => 
            tmp89 := xnew;
        END CASE;

        tmp_013 := tmp89;
      WHEN "100" =>
        tmp_013 := xnew;
      WHEN "101" =>
        tmp_013 := xnew;
      WHEN OTHERS => 
        tmp_013 := xnew;
    END CASE;

    tmp_90 <= tmp_013;
  END PROCESS p99_output;


  xnew_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      xnew <= to_unsigned(2#00000000000000#, 14);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        xnew <= tmp_90;
      END IF;
    END IF;
  END PROCESS xnew_reg_process;

  -- normalize with 1/2^21
  tmp_91 <= to_unsigned(2#00000000000000#, 14);

  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_falseregionp182
  xnew_3 <= tmp_91;

  
  tmp_92 <= xnew_3 WHEN tmp_39 = '0' ELSE
      xnew;

  p163_output : PROCESS (state_7, tmp_92, tmp_86, tmp_60, xnew)
    VARIABLE tmp93 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_7 IS
      WHEN "001" =>
        tmp93 := xnew;
      WHEN "010" =>
        tmp93 := tmp_92;
      WHEN "011" =>
        tmp93 := tmp_86;
      WHEN "100" =>
        tmp93 := xnew;
      WHEN "101" =>
        tmp93 := tmp_60;
      WHEN "110" =>
        tmp93 := xnew;
      WHEN OTHERS => 
        tmp93 := xnew;
    END CASE;

    tmp_87 <= tmp93;
  END PROCESS p163_output;


  --HDL code generation from MATLAB function: mlhdlc_kalman_hdl_fixpt_trueregionp118
  reciprocal_detS <= tmp_87;

  
  tmp_94 <= reciprocal_detS_1 WHEN tmp_38 = '0' ELSE
      reciprocal_detS;

  p81_output : PROCESS (state_6, tmp_94, reciprocal_detS_1, state_4)
    VARIABLE tmp95 : unsigned(13 DOWNTO 0);
    VARIABLE tmp_014 : unsigned(13 DOWNTO 0);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_014 := reciprocal_detS_1;
      WHEN "010" =>
        tmp_014 := reciprocal_detS_1;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp95 := reciprocal_detS_1;
          WHEN "010" =>
            tmp95 := tmp_94;
          WHEN "011" =>
            tmp95 := reciprocal_detS_1;
          WHEN "100" =>
            tmp95 := reciprocal_detS_1;
          WHEN OTHERS => 
            tmp95 := reciprocal_detS_1;
        END CASE;

        tmp_014 := tmp95;
      WHEN "100" =>
        tmp_014 := reciprocal_detS_1;
      WHEN "101" =>
        tmp_014 := reciprocal_detS_1;
      WHEN OTHERS => 
        tmp_014 := reciprocal_detS_1;
    END CASE;

    tmp_96 <= tmp_014;
  END PROCESS p81_output;


  reciprocal_detS_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      reciprocal_detS_1 <= to_unsigned(2#00000000000000#, 14);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        reciprocal_detS_1 <= tmp_96;
      END IF;
    END IF;
  END PROCESS reciprocal_detS_reg_process;


  tmp_97_gen: FOR t_06 IN 0 TO 3 GENERATE
    p196tmp_mul_temp(t_06) <= reciprocal_detS_1 * adjoint(t_06);
    tmp_97(t_06) <= p196tmp_mul_temp(t_06)(7 DOWNTO 0) & '0' & '0' & '0' & '0' & '0' & '0';
  END GENERATE tmp_97_gen;


  p75_output : PROCESS (state_6, tmp_97, invS, state_4)
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_98 <= invS;
      WHEN "010" =>
        tmp_98 <= invS;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp_98 <= invS;
          WHEN "010" =>
            tmp_98 <= invS;
          WHEN "011" =>
            tmp_98 <= tmp_97;
          WHEN "100" =>
            tmp_98 <= invS;
          WHEN OTHERS => 
            tmp_98 <= invS;
        END CASE;

      WHEN "100" =>
        tmp_98 <= invS;
      WHEN "101" =>
        tmp_98 <= invS;
      WHEN OTHERS => 
        tmp_98 <= invS;
    END CASE;

  END PROCESS p75_output;


  invS_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      invS <= (OTHERS => to_unsigned(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        invS <= tmp_98;
      END IF;
    END IF;
  END PROCESS invS_reg_process;

  p78_output : PROCESS (state_6, c_4, S_backslash_B, state_4, invS, B)
    VARIABLE c16 : vector_of_unsigned29(0 TO 11);
    VARIABLE add_cast4 : vector_of_signed64(0 TO 1);
    VARIABLE add_cast_04 : vector_of_signed64(0 TO 1);
    VARIABLE add_cast_14 : vector_of_unsigned30(0 TO 1);
    VARIABLE add_cast_24 : vector_of_signed64(0 TO 1);
    VARIABLE add_cast_34 : vector_of_signed64(0 TO 1);
    VARIABLE mul_temp1 : vector_of_unsigned28(0 TO 1);
    VARIABLE add_cast_44 : vector_of_unsigned30(0 TO 1);
    VARIABLE add_temp4 : vector_of_unsigned30(0 TO 1);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_99 <= S_backslash_B;
      WHEN "010" =>
        tmp_99 <= S_backslash_B;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp_99 <= S_backslash_B;
          WHEN "010" =>
            tmp_99 <= S_backslash_B;
          WHEN "011" =>
            tmp_99 <= S_backslash_B;
          WHEN "100" =>
            c16 := c_4;

            FOR l4 IN 0 TO 1 LOOP
              FOR m4 IN 0 TO 5 LOOP
                FOR k4 IN 0 TO 1 LOOP
                  add_cast4(k4) := resize(to_signed(m4, 32) & '0', 64);
                  add_cast_04(k4) := resize(to_signed(m4, 32) & '0', 64);
                  add_cast_14(k4) := resize(c16(to_integer(to_signed(l4, 32) + resize(add_cast_04(k4), 32))), 30);
                  add_cast_24(k4) := resize(to_signed(k4, 32) & '0', 64);
                  add_cast_34(k4) := resize(to_signed(m4, 32) & '0', 64);
                  mul_temp1(k4) := invS(to_integer(to_signed(l4, 32) + resize(add_cast_24(k4), 32))) * B(to_integer(to_signed(k4, 32) + resize(add_cast_34(k4), 32)));
                  add_cast_44(k4) := resize(mul_temp1(k4), 30);
                  add_temp4(k4) := add_cast_14(k4) + add_cast_44(k4);
                  c16(to_integer(to_signed(l4, 32) + resize(add_cast4(k4), 32))) := add_temp4(k4)(28 DOWNTO 0);
                END LOOP;
              END LOOP;
            END LOOP;


            FOR t_07 IN 0 TO 11 LOOP
              tmp_99(t_07) <= c16(t_07)(25 DOWNTO 12);
            END LOOP;

          WHEN OTHERS => 
            tmp_99 <= S_backslash_B;
        END CASE;

      WHEN "100" =>
        tmp_99 <= S_backslash_B;
      WHEN "101" =>
        tmp_99 <= S_backslash_B;
      WHEN OTHERS => 
        tmp_99 <= S_backslash_B;
    END CASE;

  END PROCESS p78_output;


  S_backslash_B_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      S_backslash_B <= (OTHERS => to_unsigned(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        S_backslash_B <= tmp_99;
      END IF;
    END IF;
  END PROCESS S_backslash_B_reg_process;

  p48_output : PROCESS (state_6, c_4, S_backslash_B, klm_gain, state_4, invS, B)
    VARIABLE tmp100 : vector_of_unsigned14(0 TO 11);
    VARIABLE c17 : vector_of_unsigned29(0 TO 11);
    VARIABLE add_cast5 : vector_of_signed64(0 TO 5);
    VARIABLE add_cast_05 : vector_of_signed64(0 TO 1);
    VARIABLE add_cast_15 : vector_of_signed64(0 TO 1);
    VARIABLE add_cast_25 : vector_of_unsigned30(0 TO 1);
    VARIABLE add_cast_35 : vector_of_signed64(0 TO 1);
    VARIABLE add_cast_45 : vector_of_signed64(0 TO 1);
    VARIABLE mul_temp2 : vector_of_unsigned28(0 TO 1);
    VARIABLE add_cast_52 : vector_of_unsigned30(0 TO 1);
    VARIABLE add_temp5 : vector_of_unsigned30(0 TO 1);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_101 <= klm_gain;
      WHEN "010" =>
        tmp_101 <= klm_gain;
      WHEN "011" =>

        CASE state_4 IS
          WHEN "001" =>
            tmp100 := S_backslash_B;
          WHEN "010" =>
            tmp100 := S_backslash_B;
          WHEN "011" =>
            tmp100 := S_backslash_B;
          WHEN "100" =>
            c17 := c_4;

            FOR l5 IN 0 TO 1 LOOP
              FOR m5 IN 0 TO 5 LOOP
                FOR k5 IN 0 TO 1 LOOP
                  add_cast_05(k5) := resize(to_signed(m5, 32) & '0', 64);
                  add_cast_15(k5) := resize(to_signed(m5, 32) & '0', 64);
                  add_cast_25(k5) := resize(c17(to_integer(to_signed(l5, 32) + resize(add_cast_15(k5), 32))), 30);
                  add_cast_35(k5) := resize(to_signed(k5, 32) & '0', 64);
                  add_cast_45(k5) := resize(to_signed(m5, 32) & '0', 64);
                  mul_temp2(k5) := invS(to_integer(to_signed(l5, 32) + resize(add_cast_35(k5), 32))) * B(to_integer(to_signed(k5, 32) + resize(add_cast_45(k5), 32)));
                  add_cast_52(k5) := resize(mul_temp2(k5), 30);
                  add_temp5(k5) := add_cast_25(k5) + add_cast_52(k5);
                  c17(to_integer(to_signed(l5, 32) + resize(add_cast_05(k5), 32))) := add_temp5(k5)(28 DOWNTO 0);
                END LOOP;
              END LOOP;
            END LOOP;


            FOR t_08 IN 0 TO 11 LOOP
              tmp100(t_08) := c17(t_08)(25 DOWNTO 12);
            END LOOP;

          WHEN OTHERS => 
            tmp100 := S_backslash_B;
        END CASE;


        FOR t_22 IN 0 TO 1 LOOP
          FOR t_16 IN 0 TO 5 LOOP
            add_cast5(t_16) := resize(to_signed(t_16, 32) & '0', 64);
            tmp_101(t_16 + (6 * t_22)) <= tmp100(to_integer(to_signed(t_22, 32) + resize(add_cast5(t_16), 32)));
          END LOOP;
        END LOOP;

      WHEN "100" =>
        tmp_101 <= klm_gain;
      WHEN "101" =>
        tmp_101 <= klm_gain;
      WHEN OTHERS => 
        tmp_101 <= klm_gain;
    END CASE;

  END PROCESS p48_output;


  klm_gain_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      klm_gain <= (OTHERS => to_unsigned(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        klm_gain <= tmp_101;
      END IF;
    END IF;
  END PROCESS klm_gain_reg_process;

  p27_output : PROCESS (state_6, c_2, x_prd, x_est)
    VARIABLE c18 : vector_of_signed18(0 TO 5);
    VARIABLE add_cast6 : vector_of_signed19(0 TO 5);
    VARIABLE t_17 : vector_of_signed14(0 TO 5);
    VARIABLE add_cast_06 : vector_of_signed15(0 TO 5);
    VARIABLE add_cast_16 : vector_of_signed19(0 TO 5);
    VARIABLE add_temp6 : vector_of_signed19(0 TO 5);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>

        FOR t_09 IN 0 TO 5 LOOP
          c18(t_09) := c_2(t_09);

          FOR k6 IN 0 TO 5 LOOP
            add_cast6(k6) := resize(c18(t_09), 19);
            IF a0_2(t_09 + (6 * k6)) = '1' THEN 
              t_17(k6) := x_est(k6);
            ELSE 
              t_17(k6) := to_signed(2#00000000000000#, 14);
            END IF;
            add_cast_06(k6) := resize(t_17(k6), 15);
            add_cast_16(k6) := resize(add_cast_06(k6), 19);
            add_temp6(k6) := add_cast6(k6) + add_cast_16(k6);
            c18(t_09) := add_temp6(k6)(17 DOWNTO 0);
          END LOOP;

          tmp_102(t_09) <= c18(t_09)(13 DOWNTO 0);
        END LOOP;

      WHEN "010" =>
        tmp_102 <= x_prd;
      WHEN "011" =>
        tmp_102 <= x_prd;
      WHEN "100" =>
        tmp_102 <= x_prd;
      WHEN "101" =>
        tmp_102 <= x_prd;
      WHEN OTHERS => 
        tmp_102 <= x_prd;
    END CASE;

  END PROCESS p27_output;


  x_prd_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      x_prd_reg_reg <= (OTHERS => to_signed(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        x_prd_reg_reg <= tmp_102;
      END IF;
    END IF;
  END PROCESS x_prd_reg_process;
  x_prd <= x_prd_reg_reg;

  p39_output : PROCESS (state_6, c_1, z_prd, x_prd)
    VARIABLE c19 : vector_of_signed18(0 TO 1);
    VARIABLE add_cast7 : vector_of_signed19(0 TO 5);
    VARIABLE add_cast_07 : vector_of_signed64(0 TO 5);
    VARIABLE t_18 : vector_of_signed14(0 TO 5);
    VARIABLE add_cast_17 : vector_of_signed15(0 TO 5);
    VARIABLE add_cast_26 : vector_of_signed19(0 TO 5);
    VARIABLE add_temp7 : vector_of_signed19(0 TO 5);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_103 <= z_prd;
      WHEN "010" =>

        FOR t_010 IN 0 TO 1 LOOP
          c19(t_010) := c_1(t_010);

          FOR k7 IN 0 TO 5 LOOP
            add_cast7(k7) := resize(c19(t_010), 19);
            add_cast_07(k7) := resize(to_signed(k7, 32) & '0', 64);
            IF a_9(to_integer(to_signed(t_010, 32) + resize(add_cast_07(k7), 32))) = '1' THEN 
              t_18(k7) := x_prd(k7);
            ELSE 
              t_18(k7) := to_signed(2#00000000000000#, 14);
            END IF;
            add_cast_17(k7) := resize(t_18(k7), 15);
            add_cast_26(k7) := resize(add_cast_17(k7), 19);
            add_temp7(k7) := add_cast7(k7) + add_cast_26(k7);
            c19(t_010) := add_temp7(k7)(17 DOWNTO 0);
          END LOOP;

          tmp_103(t_010) <= c19(t_010)(13 DOWNTO 0);
        END LOOP;

      WHEN "011" =>
        tmp_103 <= z_prd;
      WHEN "100" =>
        tmp_103 <= z_prd;
      WHEN "101" =>
        tmp_103 <= z_prd;
      WHEN OTHERS => 
        tmp_103 <= z_prd;
    END CASE;

  END PROCESS p39_output;


  z_prd_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      z_prd_reg_reg <= (OTHERS => to_signed(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        z_prd_reg_reg <= tmp_103;
      END IF;
    END IF;
  END PROCESS z_prd_reg_process;
  z_prd <= z_prd_reg_reg;


  c_20_gen: FOR t_011 IN 0 TO 1 GENERATE
    p198c_sub_cast(t_011) <= resize(z_signed(t_011), 15);
    p198c_sub_cast_1(t_011) <= resize(z_prd(t_011), 15);
    c_20(t_011) <= p198c_sub_cast(t_011) - p198c_sub_cast_1(t_011);
  END GENERATE c_20_gen;


  p51_output : PROCESS (state_6, c_20, c_3, x_est, klm_gain, x_prd)
    VARIABLE c21 : vector_of_signed30(0 TO 5);
    VARIABLE add_cast8 : vector_of_signed31(0 TO 5);
    VARIABLE add_cast_08 : vector_of_signed31(0 TO 5);
    VARIABLE add_temp8 : vector_of_signed31(0 TO 5);
    VARIABLE add_cast_18 : vector_of_signed31(0 TO 1);
    VARIABLE cast1 : vector_of_signed15(0 TO 1);
    VARIABLE mul_temp3 : vector_of_signed30(0 TO 1);
    VARIABLE add_cast_27 : vector_of_signed29(0 TO 1);
    VARIABLE add_cast_36 : vector_of_signed31(0 TO 1);
    VARIABLE add_temp_03 : vector_of_signed31(0 TO 1);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_104 <= x_est;
      WHEN "010" =>
        tmp_104 <= x_est;
      WHEN "011" =>
        tmp_104 <= x_est;
      WHEN "100" =>

        FOR t_012 IN 0 TO 5 LOOP
          c21(t_012) := c_3(t_012);

          FOR k8 IN 0 TO 1 LOOP
            add_cast_18(k8) := resize(c21(t_012), 31);
            cast1(k8) := signed(resize(klm_gain(t_012 + (6 * k8)), 15));
            mul_temp3(k8) := cast1(k8) * c_20(k8);
            add_cast_27(k8) := mul_temp3(k8)(28 DOWNTO 0);
            add_cast_36(k8) := resize(add_cast_27(k8), 31);
            add_temp_03(k8) := add_cast_18(k8) + add_cast_36(k8);
            c21(t_012) := add_temp_03(k8)(29 DOWNTO 0);
          END LOOP;

          add_cast8(t_012) := resize(x_prd(t_012) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 31);
          add_cast_08(t_012) := resize(c21(t_012), 31);
          add_temp8(t_012) := add_cast8(t_012) + add_cast_08(t_012);
          tmp_104(t_012) <= add_temp8(t_012)(28 DOWNTO 15);
        END LOOP;

      WHEN "101" =>
        tmp_104 <= x_est;
      WHEN OTHERS => 
        tmp_104 <= x_est;
    END CASE;

  END PROCESS p51_output;


  x_est_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      x_est_reg_reg <= (OTHERS => to_signed(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        x_est_reg_reg <= tmp_104;
      END IF;
    END IF;
  END PROCESS x_est_reg_process;
  x_est <= x_est_reg_reg;

  y_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      y_reg_reg <= (OTHERS => to_signed(2#00000000000000#, 14));
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        y_reg_reg <= tmp_105;
      END IF;
    END IF;
  END PROCESS y_reg_process;
  y_2 <= y_reg_reg;

  p57_output : PROCESS (state_6, c, y_2, x_est)
    VARIABLE c22 : vector_of_signed18(0 TO 1);
    VARIABLE add_cast9 : vector_of_signed19(0 TO 5);
    VARIABLE add_cast_09 : vector_of_signed64(0 TO 5);
    VARIABLE t_19 : vector_of_signed14(0 TO 5);
    VARIABLE add_cast_19 : vector_of_signed15(0 TO 5);
    VARIABLE add_cast_28 : vector_of_signed19(0 TO 5);
    VARIABLE add_temp9 : vector_of_signed19(0 TO 5);
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp_105 <= y_2;
      WHEN "010" =>
        tmp_105 <= y_2;
      WHEN "011" =>
        tmp_105 <= y_2;
      WHEN "100" =>
        tmp_105 <= y_2;
      WHEN "101" =>

        FOR t_013 IN 0 TO 1 LOOP
          c22(t_013) := c(t_013);

          FOR k9 IN 0 TO 5 LOOP
            add_cast9(k9) := resize(c22(t_013), 19);
            add_cast_09(k9) := resize(to_signed(k9, 32) & '0', 64);
            IF a_11(to_integer(to_signed(t_013, 32) + resize(add_cast_09(k9), 32))) = '1' THEN 
              t_19(k9) := x_est(k9);
            ELSE 
              t_19(k9) := to_signed(2#00000000000000#, 14);
            END IF;
            add_cast_19(k9) := resize(t_19(k9), 15);
            add_cast_28(k9) := resize(add_cast_19(k9), 19);
            add_temp9(k9) := add_cast9(k9) + add_cast_28(k9);
            c22(t_013) := add_temp9(k9)(17 DOWNTO 0);
          END LOOP;

          tmp_105(t_013) <= c22(t_013)(13 DOWNTO 0);
        END LOOP;

      WHEN OTHERS => 
        tmp_105 <= y_2;
    END CASE;

  END PROCESS p57_output;


  tmp_106 <= to_signed(16#00000000#, 32);

  tmp_107 <= tmp_105(to_integer(tmp_106));

  y1 <= std_logic_vector(tmp_107);

  tmp_108 <= to_signed(16#00000001#, 32);

  tmp_109 <= tmp_105(to_integer(tmp_108));

  y2_1 <= tmp_109(12 DOWNTO 0) & '0';

  y2 <= std_logic_vector(y2_1);

  dv_out_reg_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dv_out_2 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        dv_out_2 <= tmp_110;
      END IF;
    END IF;
  END PROCESS dv_out_reg_1_process;

  p33_output : PROCESS (state_6, dv_out_2)
    VARIABLE tmp111 : std_logic;
  BEGIN

    CASE state_6 IS
      WHEN "001" =>
        tmp111 := '0';
      WHEN "010" =>
        tmp111 := dv_out_2;
      WHEN "011" =>
        tmp111 := dv_out_2;
      WHEN "100" =>
        tmp111 := dv_out_2;
      WHEN "101" =>
        tmp111 := '1';
      WHEN OTHERS => 
        tmp111 := dv_out_2;
    END CASE;

    tmp_110 <= tmp111;
    
  END PROCESS p33_output;


  dv_out_q_1 <= tmp_110;

  dv_out_q <= dv_out_q_1;

  ce_out <= clk_enable;

END rtl;

