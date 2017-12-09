    docker ps > /tmp/yy_xx$$
    if grep --quiet web1 /tmp/yy_xx$$
     then
	 docker run -d --network=ecs189_default --name=web2 $1
	 sleep 1 && docker exec ecs189_proxy_1 /bin/bash /bin/swap2.sh
     echo "killing older version of web1"
	 docker rm -f `docker ps -a | grep web1  | sed -e 's: .*$::'`
	 
	 
   fi

     if grep --quiet web2 /tmp/yy_xx$$
     then
	echo "killing older version of web2"
	 docker run -d --network=ecs189_default --name=web1 $1
	 sleep 1 && docker exec ecs189_proxy_1 /bin/bash /bin/swap1.sh
	 docker rm -f `docker ps -a | grep web2  | sed -e 's: .*$::'`

	 
	 
   fi
   