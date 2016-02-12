ps = linspace(0,10,11)/10.0;
actual_ps = zeros(1,10);
    
for p = ps
    total_p = 0;
    for i = 1:10
       [n1Spikes, n2Spikes, n3Spikes, actual_p] = generate_random_xor(p,false);
       total_p = total_p + actual_p;
    end
    actual_ps(round(p*10)+1) = total_p / 10.0;
end

plot(ps,actual_ps);
title('Probabilisitic XOR');
xlabel('Probability Neuron 3 = XOR(Neuron 1, Neuron 2)');
ylabel('True Probability');