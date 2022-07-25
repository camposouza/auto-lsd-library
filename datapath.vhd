library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity datapath is
  port (
			  -- clock input
			  clock : in STD_LOGIC;
			  
			  -- users inputs
			  pegar_in                        : in STD_LOGIC;
			  devolver_in                     : in STD_LOGIC;
			  id_in                           : in STD_LOGIC_VECTOR(15 downto 0);
			  cod_concat_in                   : in STD_LOGIC_VECTOR(15 downto 0);
			  codigo_in                       : in STD_LOGIC_VECTOR(15 downto 0);
			  escolhe_concat_memoria_in       : in STD_LOGIC;
			  escolhe_concat_ctrl_passagem_in : in STD_LOGIC;
			  escolhe_comp_in                 : in STD_LOGIC;
			  
			  -- registers
			  pegar_ld          : in STD_LOGIC;
			  pegar_rst         : in STD_LOGIC;
			  devolver_ld       : in STD_LOGIC;
			  devolver_rst      : in STD_LOGIC;
			  id_ld             : in STD_LOGIC;
			  id_rst            : in STD_LOGIC;
			  cod_concat_ld     : in STD_LOGIC;
			  cod_concat_rst    : in STD_LOGIC;
			  codigo_ld         : in STD_LOGIC;
			  codigo_rst        : in STD_LOGIC;
			  debito_ld         : in STD_LOGIC;
			  debito_rst        : in STD_LOGIC;
			  passagem_ld       : in STD_LOGIC;
			  passagem_rst      : in STD_LOGIC;
			  
			  memoria_ld        : in STD_LOGIC;
			  memoria_rst       : in STD_LOGIC;
			  
			  -- outputs
			  passagem_out      : out STD_LOGIC_VECTOR(16 downto 0);
			  memoria_out       : out STD_LOGIC_VECTOR(31 downto 0);
			  comp_codigo_out   : out STD_LOGIC;
			  debito_out        : out STD_LOGIC_VECTOR(15 downto 0);
			  devolver_out      : out STD_LOGIC;
			  pegar_out         : out STD_LOGIC
			);
end entity;

architecture rtl of datapath is
  -- registers
  component reg_1bit is
    port (
          clock : in STD_LOGIC;
			 
			 reg_in  : in STD_LOGIC;
			 reg_ld  : in STD_LOGIC;
			 reg_rst : in STD_LOGIC;
			 
			 reg_out : out STD_LOGIC 
         );
  end component;
  
  component reg_16bits is
    port (
          clock : in STD_LOGIC;
			 
			 reg_in  : in STD_LOGIC_VECTOR(15 downto 0);
			 reg_ld  : in STD_LOGIC;
			 reg_rst : in STD_LOGIC;
			 reg_out : out STD_LOGIC_VECTOR(15 downto 0)
         );
  end component;
  
  component reg_concat_17bits is
  port (
          clock : in STD_LOGIC;
			 
			 reg_in        : in STD_LOGIC_VECTOR(15 downto 0);
			 bit_concat    : in STD_LOGIC;
			 reg_ld        : in STD_LOGIC;
			 reg_rst       : in STD_LOGIC;
			 reg_out       : out STD_LOGIC_VECTOR(16 downto 0)
       );
  end component;
  
  component reg_concat_32bits is
  port (
          clock : in STD_LOGIC;
			 
			 reg_in        : in STD_LOGIC_VECTOR(15 downto 0);
			 vector_concat : in STD_LOGIC_VECTOR(15 downto 0);
			 reg_ld        : in STD_LOGIC;
			 reg_rst       : in STD_LOGIC;
			 reg_out       : out STD_LOGIC_VECTOR(31 downto 0)
       );
  end component;
  
  -- muxes
  component mux2_1bit is
    port(
          A1      : in  STD_LOGIC;
          A2      : in  STD_LOGIC;
			 SEL     : in  STD_LOGIC;
          B       : out STD_LOGIC
		  );
  end component;
  
  component mux2 is
    generic (N:integer := 16);
    port(
          A1      : in  STD_LOGIC_VECTOR(N-1 downto 0);
          A2      : in  STD_LOGIC_VECTOR(N-1 downto 0);
			 SEL     : in  STD_LOGIC;
          B       : out STD_LOGIC_VECTOR(N-1 downto 0)
		   );
  end component;
  
  component comp is
	generic (N:integer := 8);
	port (  
			  A  : IN STD_LOGIC_VECTOR(N-1 downto 0);
			  B  : IN STD_LOGIC_VECTOR(N-1 downto 0);
			  eq : OUT STD_LOGIC
			);

  end component;

  signal reg_id_out, reg_cod_concat_out, reg_codigo_out, mux_memoria_out, mux_comp_out : STD_LOGIC_VECTOR(15 downto 0);
  signal mux_passagem_out : STD_LOGIC;
  
 
  begin
  
  reg_pegar : reg_1bit port map(clock, pegar_in, pegar_ld, pegar_rst, pegar_out);
  reg_devolver : reg_1bit port map(clock, devolver_in, devolver_ld, devolver_rst, devolver_out);
  reg_id : reg_16bits port map(clock, id_in, id_ld, id_rst, reg_id_out);
  reg_cod_concat : reg_16bits port map(clock, cod_concat_in, cod_concat_ld, cod_concat_rst, reg_cod_concat_out);
  reg_codigo : reg_16bits port map(clock, codigo_in, codigo_ld, codigo_rst, reg_codigo_out);
  reg_ctrl_passagem : reg_concat_17bits port map(clock, reg_codigo_out, mux_passagem_out, passagem_ld, passagem_rst, passagem_out);
  reg_memoria : reg_concat_32bits port map(clock, reg_id_out, mux_memoria_out, memoria_ld, memoria_rst, memoria_out);
  reg_debito : reg_16bits port map(clock, reg_cod_concat_out, debito_ld, debito_rst, debito_out);
  
  escolhe_conc_ctrl_passagem : mux2_1bit port map('0', '1', escolhe_concat_ctrl_passagem_in, mux_passagem_out);
  escolhe_concat_memoria: mux2 generic map (N => 16) port map(reg_codigo_out, "0000000000000000", escolhe_concat_memoria_in, mux_memoria_out);
  escolhe_comparacao : mux2 generic map (N => 16) port map("0000000000000000", reg_codigo_out, escolhe_comp_in, mux_comp_out);
  
  compara_codigo : comp generic map (N => 16) port map (reg_cod_concat_out, mux_comp_out, comp_codigo_out);
  
  
end rtl;
  