:local hiPriority 200; # @master - 200; @backup - 100
:local loPriority 50;

:local iface1Running [/interface ethernet get [find where name=ether1] running];
:local iface2Running [/interface ethernet get [find where name=ether2] running];
:local iface5Running [/interface ethernet get [find where name=ether5] running];

:local desiredPriority $hiPriority;
:if (($iface1Running = false) or ($iface2Running = false) or ($iface5Running = false)) do={
    :set desiredPriority $loPriority;
}

:foreach v in=[/interface vrrp find] do={
    :local curPriority [/interface vrrp get $v priority];
    :if ($curPriority != $desiredPriority) do={
        /interface vrrp set $v priority=$desiredPriority;
        :log info ("VRRP $v priority changed to $desiredPriority");
    }
}