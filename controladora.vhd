library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity controladora is
port (
       clk : in STD_LOGIC;
		 
		 rst            : in STD_LOGIC;
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
end controladora;

architecture rtl of controladora is
	
	type estado is (INICIO, SELECAO, LOGIN, ARMAZENA_DADOS,
    				    VERIFICA_DEBITO, LE_CODIGO, ARMAZENA_CODIGO,
                   USA_CODIGO, IMPRIME_DEBITO, DEVOLVE_LIVRO, EMPRESTA_LIVRO);
						 
	 signal estado_atual		: estado := INICIO;
    signal proximo_estado	: estado;

	 
begin

    process(clk, rst) is
    begin
		  if (rst = '1') then
		      estado_atual <= INICIO;	
        elsif (rising_edge(clk)) then
            estado_atual <= proximo_estado;
        end if;
    end process;
    
    process(estado_atual, pegar, devolver, leitor_cartao,
            leitor_livro, reg_pegar, reg_devolver, compara_codigo) is
    begin
	 
	    id_rst							   <= '0';
       debito_rst						   <= '0';
       pegar_rst						   <= '0';
       devolver_rst					   <= '0';
       cod_concat_rst				   <= '0';
       codigo_rst						   <= '0';
       memoria_rst						<= '0';
       ctrl_passagem_rst		    	<= '0';
       id_ld							   <= '0';
       debito_ld						   <= '0';
       pegar_ld						   <= '0';
       devolver_ld						<= '0';
       cod_concat_ld				      <= '0';
       codigo_ld						   <= '0';
       memoria_ld						   <= '0';
       ctrl_passagem_ld		    	   <= '0';
       led_cartao						   <= '0';
       led_livro						   <= '0';
       escolhe_comp				   	<= '0';
       escolhe_concat_memoria		   <= '0';
       escolhe_concat_ctrl_passagem	<= '0';
	 
        case estado_atual is
        
            when INICIO =>
                memoria_ld <= '0';
                ctrl_passagem_ld <= '0';
                id_rst <= '1';
                debito_rst <= '1';
                pegar_rst <= '1';
                devolver_rst <= '1';
                cod_concat_rst <= '1';
                codigo_rst <= '1';
                -- memoria_rst <= '1';
                -- ctrl_passagem_rst <= '1';
                led_cartao <= '0';
                
                proximo_estado <= SELECAO;
            
            when SELECAO =>
                id_rst <= '0';
                debito_rst <= '0';
                pegar_rst <= '0';
                devolver_rst <= '0';
                cod_concat_rst <= '0';
                codigo_rst <= '0';
                --memoria_rst <= '0';
                --ctrl_passagem_rst <= '0';
                pegar_ld <= '1';
                devolver_ld <= '1';
					 memoria_rst <= '1';
                ctrl_passagem_rst <= '1';
                
                if (((pegar = '1') and (devolver = '0')) or 
					     ((pegar = '0') and (devolver = '1'))) then
                    proximo_estado <= LOGIN;
                else
                    proximo_estado <= SELECAO;
                end if;
                
            when LOGIN =>
                pegar_ld <= '0';
                devolver_ld <= '0';
                led_cartao <= '1';
					 memoria_rst <= '0';
                ctrl_passagem_rst <= '0';
                
                if (leitor_cartao = '1') then
                    proximo_estado <= ARMAZENA_DADOS;
                else
                    proximo_estado <= LOGIN;
                end if;
                
            when ARMAZENA_DADOS =>
                cod_concat_ld <= '1';
                id_ld <= '1';
                escolhe_comp <= '0';
                
                proximo_estado <= VERIFICA_DEBITO;
                
            when VERIFICA_DEBITO =>
                cod_concat_ld <= '0';
                id_ld <= '0';
                
                if ((reg_devolver = '1') and (compara_codigo = '1')) then
                    proximo_estado <= SELECAO;
                elsif ((reg_pegar = '1') and (compara_codigo = '0')) then
                    proximo_estado <= IMPRIME_DEBITO;
                elsif (((reg_devolver = '1') and (compara_codigo = '0')) or 
                      ((reg_pegar = '1') and (compara_codigo = '1'))) then
                    proximo_estado <= LE_CODIGO;
                else
                    proximo_estado <= VERIFICA_DEBITO;
                end if;
                
            when LE_CODIGO =>
                led_livro <= '1';
                
                if (leitor_livro = '1') then
                    proximo_estado <= ARMAZENA_CODIGO;
                else
                    proximo_estado <= LE_CODIGO;
                end if;
                
            when ARMAZENA_CODIGO =>
                codigo_ld <= '1';
                
                proximo_estado <= USA_CODIGO;
                
            when USA_CODIGO =>
                codigo_ld <= '0';
                led_livro <= '0';
                escolhe_comp <= '1';
                
                if (reg_pegar = '1') then
                    proximo_estado <= EMPRESTA_LIVRO;
                elsif ((reg_devolver = '1') and (compara_codigo = '1')) then
                    proximo_estado <= DEVOLVE_LIVRO;
                elsif ((reg_devolver = '1') and (compara_codigo = '0')) then
                    proximo_estado <= IMPRIME_DEBITO;
                else 
                    proximo_estado <= USA_CODIGO;
                end if;
                
            when IMPRIME_DEBITO =>
                debito_ld <= '1';
                
                if (reg_pegar = '1') then
                    proximo_estado <= SELECAO;
                elsif (reg_devolver = '1') then
                    proximo_estado <= INICIO;
                else
                    proximo_estado <= IMPRIME_DEBITO;
                end if;
                
            when EMPRESTA_LIVRO =>
                memoria_ld <= '1';
                ctrl_passagem_ld <= '1';
                escolhe_concat_memoria <= '1';
                escolhe_concat_ctrl_passagem <= '1';
                
                proximo_estado <= INICIO;
                
            when DEVOLVE_LIVRO =>
                memoria_ld <= '1';
                ctrl_passagem_ld <= '1';
                escolhe_concat_memoria <= '0';
                escolhe_concat_ctrl_passagem <= '0';
                
                proximo_estado <= INICIO;
        end case;
    end process;
end rtl;