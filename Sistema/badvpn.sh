#!/bin/bash
fun_badvpn() {
    clear
    echo -e "\E[44;1;37m          🌟 GERENCIAR BADVPN FULL 🌟      \E[0m"
    echo ""
    if ps x | grep -w udpvpn | grep -v grep 1>/dev/null 2>/dev/null; then
        echo -e "\033[1;33mPORTAS\033[1;37m: \033[1;32m$(netstat -nplt | grep 'badvpn-ud' | awk {'print $4'} | cut -d: -f2 | xargs)"
    else
        sleep 0.1
    fi
    var_sks1=$(ps x | grep "udpvpn"|grep -v grep > /dev/null && echo -e "\033[1;32m◉ " || echo -e "\033[1;31m○ ")
    echo ""
    echo -e "\033[1;31m[\033[1;36m1\033[1;31m] \033[1;37m• \033[1;33mATIVAR BADVPN FULL(PADRÃO 7300) $var_sks1 \033[0m"
    echo -e "\033[1;31m[\033[1;36m2\033[1;31m] \033[1;37m• \033[1;33mABRIR PORTA\033[0m"
    echo -e "\033[1;31m[\033[1;36m0\033[1;31m] \033[1;37m• \033[1;33mVOLTAR\033[0m"
    echo ""
    echo -ne "\033[1;32mO QUE DESEJA FAZER \033[1;33m?\033[1;37m "
    read resposta
    if [[ "$resposta" = '1' ]]; then
        if ps x | grep -w udpvpn | grep -v grep 1>/dev/null 2>/dev/null; then
            clear
            echo -e "\E[41;1;37m             BADVPN              \E[0m"
            echo ""
            fun_stopbad () {
                sleep 1
                for pidudpvpn in $(screen -ls | grep ".udpvpn" | awk {'print $1'}); do
                    screen -r -S "$pidudpvpn" -X quit
				done
                [[ $(grep -wc "udpvpn" /etc/autostart) != '0' ]] && {
                    sed -i '/udpvpn/d' /etc/autostart
                }
                sleep 1
                screen -wipe >/dev/null
            }
            echo -e "\033[1;32mDESATIVANDO O BADVPN\033[1;33m"
            echo ""
            fun_stopbad
            echo ""
            echo -e "\033[1;32mBADVPN DESATIVADO COM SUCESSO!\033[1;33m"
            sleep 3
            fun_badvpn
        else
            clear
            echo -e "\033[1;32mINICIANDO O BADVPN... \033[0m\n"
            fun_udpon () {
                screen -dmS udpvpn BADVPN-FULL.sh
                [[ $(grep -wc "udpvpn" /etc/autostart) = '0' ]] && {
                    echo -e "ps x | grep 'udpvpn' | grep -v 'grep' || screen -dmS udpvpn BADVPN-FULL.sh" >> /etc/autostart
                } || {
                    sed -i '/udpvpn/d' /etc/autostart
                    echo -e "ps x | grep 'udpvpn' | grep -v 'grep' || screen -dmS udpvpn BADVPN-FULL.sh" >> /etc/autostart
                }
                sleep 1
            }
            inst_udp () {
                [[ -e "/bin/badvpn-udpgw" ]] && {
                    sleep 0.1
                } || {
                    cd $HOME
					rm -r -f /bin/badvpn-udpgw
					rm -r -f /bin/BADVPN-FULL.sh
                    wget https://raw.githubusercontent.com/alfainternet/sshplus2/main/Sistema/badvpn-udpgw -o /dev/null
					wget https://raw.githubusercontent.com/alfainternet/sshplus2/main/Sistema/BADVPN-FULL.sh -o /dev/null
                    mv -f $HOME/badvpn-udpgw /bin/badvpn-udpgw
					mv -f $HOME/BADVPN-FULL.sh /bin/BADVPN-FULL.sh
                    chmod 777 /bin/badvpn-udpgw
					chmod 777 /bin/BADVPN-FULL.sh
                }
            }
            echo ""
            inst_udp
            fun_udpon
            echo ""
            echo -e "\033[1;32mBADVPN ATIVADO COM SUCESSO\033[1;33m"
			echo -e "\033[1;32mBADVPN CONFIGURADO PARA 10Mil CONEXÕES POR USUÁRIO\033[1;33m"
            sleep 4
            fun_badvpn
        fi
    elif [[ "$resposta" = '2' ]]; then
        if ps x | grep -w udpvpn | grep -v grep 1>/dev/null 2>/dev/null; then
            clear
            echo -e "\E[44;1;37m            BADVPN             \E[0m"
            echo ""
            echo -ne "\033[1;32mQUAL PORTA DESEJA ULTILIZAR \033[1;33m?\033[1;37m: "
            read porta
            [[ -z "$porta" ]] && {
                echo ""
                echo -e "\033[1;31mPorta invalida!"
                sleep 2
                clear
                menu
            }
            echo ""
            echo -e "\033[1;32mINICIANDO O BADVPN NA PORTA \033[1;31m$porta\033[1;33m"
            echo ""
            fun_abrirptbad() {
                sleep 1
                screen -dmS udpvpn /bin/badvpn-udpgw --listen-addr 127.0.0.1:$porta --max-clients 10000 --max-connections-for-client 10000
                sleep 1
            }
            fun_abrirptbad
            echo ""
            echo -e "\033[1;32mBADVPN ATIVADO COM SUCESSO\033[1;33m"
            sleep 2
            fun_badvpn
        else
            clear
            echo -e "\033[1;31mFUNCAO INDISPONIVEL\n\n\033[1;33mATIVE O BADVPN PRIMEIRO !\033[1;33m"
            sleep 2
            fun_badvpn
        fi
    elif [[ "$resposta" = '0' ]]; then
        echo ""
        echo -e "\033[1;31mRetornando...\033[0m"
        sleep 1
        menu
    else
        echo ""
        echo -e "\033[1;31mOpcao invalida !\033[0m"
        sleep 1
        fun_badvpn
    fi
}
fun_badvpn
