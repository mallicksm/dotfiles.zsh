#!/bin/zsh
#===============================================================================
# kbd
#  Author: Soummya Mallick
#  usage: kbd --help
#  Comments: Enable or disable laptop keyboard
#===============================================================================
function kbd () {
   zparseopts -E -D -- \
              -help+=o_help h+=o_help \
              -action:=o_action a:=o_action \

   o_help=${${o_help/(--help|-h)/yes}/ //}
   o_action=${${o_action/(--action|-a)/}/ //}

   if [[ "$o_help" == "yes" ]]; then
      cat <<- EOF
		=============================================================================== 
		   usage: kbd [(--help|-h)] [(--action|-h) (disable|enable) ]
		     enable                    -enables Laptop Keyboard
		     disable                   -disable Laptop Keyboard
		=============================================================================== 
		EOF
      return
   fi

   kbd_id=$(xinput --list | grep 'AT Translated Set'|sed 's/.*id=\(\S*\).*/\1/')
   npl_id=$(xinput --list | grep 'PS/2 Generic Mouse'|sed 's/.*id=\(\S*\).*/\1/')
   tpd_id=$(xinput --list | grep 'SynPS/2 Synaptics TouchPad'|sed 's/.*id=\(\S*\).*/\1/')
   master_kbd_id=$(xinput --list | grep 'master keyboard'|sed 's/.*id=\(\S*\).*/\1/')
   master_ptr_id=$(xinput --list | grep 'master pointer'|sed 's/.*id=\(\S*\).*/\1/')

   if [[ "$o_action" == "disable" ]]; then
      print -P "%F{red}Info: Disabling Keyboard+Touchpad+Nipple%f"
      xinput --float $kbd_id
      xinput --float $npl_id
      xinput --float $tpd_id
   elif [[ "$o_action" == "enable" ]]; then
      print -P "%F{blue}Info: enabling Keyboard+Touchpad+Nipple%f"
      xinput --reattach $kbd_id $master_kbd_id
      xinput --reattach $npl_id $master_ptr_id
      xinput --reattach $tpd_id $master_ptr_id
   elif [[ "$o_action" == "status" ]]; then
      print -P "%F{green}Info: Keyboard+Touchpad+Nipple%f"
      xinput --list
   else
      print -P "%F{red}Attention: Unsupported action%f"
      kbd -h
   fi
}
