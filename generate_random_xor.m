function [n1Spikes, n2Spikes, n3Spikes, actual_p] = generate_random_xor(p, random)
    n1Spikes = round(rand(1,700));
    n2Spikes = round(rand(1,700));
    n3Spikes = zeros(1,700);
    
    for i = 1:length(n3Spikes)
       if rand(1) <= p
           n3Spikes(i) = xor(n1Spikes(i),n2Spikes(i));
       else
           n3Spikes(i) = round(rand(1));
       end
    end
    
    count = 0;
    for i = 1:length(n3Spikes)
        if n3Spikes(i) == xor(n1Spikes(i),n2Spikes(i))
            count = count + 1;
        end
    end
    actual_p = count / length(n3Spikes);
    
    n3Spikes = circshift(n3Spikes,[0,1]);
    n1Spikes = n1Spikes(2:end-1);
    n2Spikes = n2Spikes(2:end-1);
    n3Spikes = n3Spikes(2:end-1);
    
    if random
        n3Spikes = n3Spikes(randperm(length(n3Spikes)));
    end
end