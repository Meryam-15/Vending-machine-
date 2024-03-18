library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity vending_machine is
    port(
        nRST : in std_logic;  
        clk : in std_logic;
        
        C : in std_logic := '0'; -- devient 1 lorsque la piece est detectee  
        V : in std_logic_vector(7 downto 0) := (others => '0'); -- recevoir la valeur de la piece 
        choice : in std_logic_vector(7 downto 0); -- le type du choix ( cafe ) 
        
        
        somme : out std_logic_vector(7 downto 0) ; -- la somme des pieces 
        voy_cafe_delivree, voy_monnaie_insuffusante : out std_logic := '0';
        E : out std_logic_vector(7 downto 0) --retourner le reste de monnaie
    );
end vending_machine;

architecture behavioral of vending_machine is
signal valeur_totale_piece: std_logic_vector (7 downto 0) ;  -- Valeur totale des pièces insérées
signal le_reste : std_logic_vector (7 downto 0) ; -- Monnaie restante à retourner

-- type des cafe avec leurs prix :
signal Espreso : std_logic_vector (7 downto 0) := "00000111" ; -- 7dh 

signal Nespreso : std_logic_vector (7 downto 0) := "00001000" ; -- 8dh 


signal Lait_au_chocolat : std_logic_vector (7 downto 0) := "00001010" ; -- 10dh 


signal Lait : std_logic_vector (7 downto 0) := "00000110" ;  -- 6dh 


signal Cappucino : std_logic_vector (7 downto 0) := "00001010" ; -- 10dh 

-- type des choix :
constant E_CH1 : std_logic_vector (7 downto 0) := "00000001" ; -- premier choix : Espreso
constant N_CH2 : std_logic_vector (7 downto 0) := "00000010" ; -- deuxieme choix  : Nespreso
constant LC_CH3 : std_logic_vector (7 downto 0) := "00000011" ; -- troisieme choix : Lait_au_chocolat
constant L_CH4 : std_logic_vector (7 downto 0) := "00000100";  -- quatrieme choix : Lait
constant C_CH5 : std_logic_vector (7 downto 0) := "00000101" ; -- cinqieme choix : Cappucino

begin

    -- Process for detecting inserted coins and updating total coin value
    process(C , V , clk, nRST )
    begin
        if rising_edge(clk) then
            if nRST = '0' then
                valeur_totale_piece <= ( others => '0' )  ;
            elsif C = '1' then -- piece detectee
				case  V is 
					when "00000001" => valeur_totale_piece <= valeur_totale_piece + V ;-- piece 1dh
					when "00000010" => valeur_totale_piece <= valeur_totale_piece + V ;-- piece 2dh
					when "00000101" => valeur_totale_piece <= valeur_totale_piece + V ;-- piece 5dh
					when "00001010" => valeur_totale_piece <= valeur_totale_piece + V ;-- piece 10dh
					when others => null ;
				end case ;
            end if;
        end if;
    end process;

   -- Processus de détection des pièces insérées et de mise à jour de la valeur totale des pièces
    process(clk, nRST , choice )
    begin
        if rising_edge(clk) then
            if nRST = '0' then
                voy_cafe_delivree <= '0'; 
                le_reste <= ( others => '0' )  ;
            else
                case choice is
                    when E_CH1 => 
                        if valeur_totale_piece >= Espreso then 
                            voy_cafe_delivree <= '1';
                            voy_monnaie_insuffusante  <= '0' ; 
                            le_reste <= valeur_totale_piece - Espreso ;
                        else
                            le_reste <= ( others => '0' ) ;
                            voy_monnaie_insuffusante  <= '1' ;  
                            voy_cafe_delivree <= '0';
                        end if;
                    when N_CH2 => 
                        if valeur_totale_piece >= Nespreso then 
                            voy_cafe_delivree <= '1';
                            voy_monnaie_insuffusante  <= '0' ; 
                            le_reste <= valeur_totale_piece - Nespreso ;
                        else
                            
                            le_reste <= ( others => '0' ) ;
                            voy_monnaie_insuffusante  <= '1' ; 
                            voy_cafe_delivree <= '0';
                        end if;
                     when LC_CH3 => 
                        if valeur_totale_piece >= Lait_au_chocolat then 
                            voy_cafe_delivree <= '1';
                            voy_monnaie_insuffusante  <= '0' ; 
                            le_reste <= valeur_totale_piece - Lait_au_chocolat ;
                        else
                            
                            le_reste <= ( others => '0' ) ;
                            voy_monnaie_insuffusante  <= '1' ; 
                            voy_cafe_delivree <= '0';
                        end if;
                      when L_CH4 => 
                        if valeur_totale_piece >= Lait then 
                            voy_cafe_delivree <= '1';
                            voy_monnaie_insuffusante  <= '0' ; 
                            le_reste <= valeur_totale_piece - Lait ;
                        else
                            
                            le_reste <= ( others => '0' ) ;
                            voy_monnaie_insuffusante  <= '1' ; 
                            voy_cafe_delivree <= '0';
                        end if;
                      when C_CH5 => 
                        if valeur_totale_piece >= Cappucino then 
                            voy_cafe_delivree <= '1';
                            voy_monnaie_insuffusante  <= '0' ; 
                            le_reste <= valeur_totale_piece - Cappucino ;
                        else
                            le_reste <= ( others => '0' ) ;
                            voy_monnaie_insuffusante  <= '1' ;
                            voy_cafe_delivree <= '0'; 
                        end if;
                    -- Ajoutez d'autres cas pour d'autres types de café si nécessaire
                    when others =>
                        voy_cafe_delivree <= '0';
                        voy_monnaie_insuffusante  <= '0' ; 
                        le_reste <= ( others => '0' ) ;
                end case;
            end if;
        end if;
    end process;

    -- Output signals

	somme <= valeur_totale_piece ;
    E <= le_reste ;

end behavioral;