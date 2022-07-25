library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sd_library is
    port (
    clk : in STD_LOGIC;
	 rst : in STD_LOGIC;
	 
    leitor_cartao	: in STD_LOGIC;
    leitor_livro	: in STD_LOGIC;
    pegar         : in STD_LOGIC;
    devolver      : in STD_LOGIC;
    id            : in STD_LOGIC_VECTOR(15 downto 0);
    cod_concat    : in STD_LOGIC_VECTOR(15 downto 0);
    codigo        : in STD_LOGIC_VECTOR(15 downto 0);
    
    led_livro         : out STD_LOGIC;
    led_cartao        : out STD_LOGIC;
    ctrl_passagem_out : out STD_LOGIC_VECTOR(16 downto 0);
    memoria_out       : out STD_LOGIC_VECTOR(31 downto 0);
    debito_out        : out STD_LOGIC_VECTOR(15 downto 0)
    );
end entity;

architecture rtl of sd_library is

    signal reg_pegar, reg_devolver, compara_codigo : STD_LOGIC;
    
    signal pegar_ld, pegar_rst, devolver_ld, devolver_rst, cod_contat_ld, cod_concat_rst,
	        id_ld, id_rst, debito_ld, debito_rst, codigo_ld, codigo_rst, 
           memoria_ld, memoria_rst, ctrl_passagem_ld, ctrl_passagem_rst,
           escolhe_comp, escolhe_concat_memoria, escolhe_concat_ctrl_passagem : STD_LOGIC;
    
    component controladora is
    port (
       clk : in STD_LOGIC;
		 rst : in STD_LOGIC;
		 
	    pegar          : in STD_LOGIC;
       devolver       : in STD_LOGIC;
       leitor_cartao  : in STD_LOGIC;
       leitor_livro	 : in STD_LOGIC;
       reg_pegar	    : in STD_LOGIC;
       reg_devolver	 : in STD_LOGIC;
       compara_codigo : in STD_LOGIC;
       
		 id_ld				 : out STD_LOGIC;
       id_rst				 : out STD_LOGIC;
		 debito_ld			 : out STD_LOGIC;
       debito_rst			 : out STD_LOGIC;
		 pegar_ld		    : out STD_LOGIC;
       pegar_rst		    : out STD_LOGIC;
		 devolver_ld	    : out STD_LOGIC;
       devolver_rst      : out STD_LOGIC;
		 cod_concat_ld		 : out STD_LOGIC;
       cod_concat_rst    : out STD_LOGIC;
		 codigo_ld			 : out STD_LOGIC;
       codigo_rst			 : out STD_LOGIC;
		 memoria_ld			 : out STD_LOGIC;
       memoria_rst		 : out STD_LOGIC;
		 ctrl_passagem_ld  : out STD_LOGIC;
       ctrl_passagem_rst : out STD_LOGIC;
		 
		 escolhe_comp				   	: out STD_LOGIC;
       escolhe_concat_memoria		   : out STD_LOGIC;
       escolhe_concat_ctrl_passagem	: out STD_LOGIC;
		 
       led_cartao : out STD_LOGIC;
       led_livro	: out STD_LOGIC 
         );
    end component;
    
    component datapath is
      port (
          clock                           : in STD_LOGIC;
          pegar_in                        : in STD_LOGIC;
          devolver_in                     : in STD_LOGIC;
          id_in                           : in STD_LOGIC_VECTOR(15 downto 0);
          cod_concat_in                   : in STD_LOGIC_VECTOR(15 downto 0);
          codigo_in                       : in STD_LOGIC_VECTOR(15 downto 0);
          escolhe_concat_memoria_in       : in STD_LOGIC;
          escolhe_concat_ctrl_passagem_in : in STD_LOGIC;
          escolhe_comp_in                 : in STD_LOGIC;
          
          -- registers
          pegar_ld       : in STD_LOGIC;
          pegar_rst      : in STD_LOGIC;
          devolver_ld    : in STD_LOGIC;
          devolver_rst   : in STD_LOGIC;
          id_ld          : in STD_LOGIC;
          id_rst         : in STD_LOGIC;
          cod_concat_ld  : in STD_LOGIC;
          cod_concat_rst : in STD_LOGIC;
          codigo_ld      : in STD_LOGIC;
          codigo_rst     : in STD_LOGIC;
          debito_ld      : in STD_LOGIC;
          debito_rst     : in STD_LOGIC;
          passagem_ld    : in STD_LOGIC;
          passagem_rst   : in STD_LOGIC;
          memoria_ld     : in STD_LOGIC;
          memoria_rst    : in STD_LOGIC;
          
          -- outputs
          passagem_out    : out STD_LOGIC_VECTOR(16 downto 0);
          memoria_out     : out STD_LOGIC_VECTOR(31 downto 0);
          comp_codigo_out : out STD_LOGIC;
          debito_out      : out STD_LOGIC_VECTOR(15 downto 0);
          devolver_out    : out STD_LOGIC;
          pegar_out       : out STD_LOGIC
        );
    end component;
    
begin
    
    instancia_controladora : controladora port map
	                         (clk, rst,
									  pegar, devolver, leitor_cartao, leitor_livro, reg_pegar, reg_devolver, compara_codigo, 
									  id_ld, id_rst, debito_ld, debito_rst, pegar_ld, pegar_rst, 
									  devolver_ld, devolver_rst, cod_contat_ld, cod_concat_rst, 
									  codigo_ld, codigo_rst, memoria_ld, memoria_rst, ctrl_passagem_ld, ctrl_passagem_rst,
									  escolhe_comp, escolhe_concat_memoria,escolhe_concat_ctrl_passagem,
									  led_cartao, led_livro);
																	
    instancia_datapath : datapath port map
	                     (clk,
								 pegar, devolver, id, cod_concat, codigo, escolhe_concat_memoria, escolhe_concat_ctrl_passagem, escolhe_comp,
							    pegar_ld, pegar_rst, devolver_ld, devolver_rst, id_ld, id_rst,
								 cod_contat_ld, cod_concat_rst, codigo_ld, codigo_rst, debito_ld, debito_rst,
                         ctrl_passagem_ld, ctrl_passagem_rst, memoria_ld, memoria_rst,
                         ctrl_passagem_out, memoria_out, compara_codigo, debito_out, reg_devolver, reg_pegar);
    
end rtl;