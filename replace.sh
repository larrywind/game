#!/bin/bash


#sed  s#'\[20141212'#'\n\[20141212'#g
#cat framed_$i.log |sed  s#"\[$i"#"\n\[$i"#g | more


for (( i=20141210; i<=20141226; i++ )); 
do 
    echo $i; 
	sed  -i s#"\[$i"#"\n\[$i"#g framed_$i.log*
done

