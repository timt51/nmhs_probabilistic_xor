% Run to use NMHS 3D (static) to find connectivity between three
% randomly generated spike trains related by XOR. Connectivities stored
% in variable max_connectivities. To shuffle data, uncomment
% line 17.

addpath(genpath('./'),'-end');
coef = 1.05;
max_connectivities = {};

parfor (j=1:11, 11)
    %countspikes 5ms
    [n1Spikes,n2spikes,n3Spikes,~] = generate_random_xor((j-1)/10.0,false);

%     tmatArchetypes = {'null hypothesis', 'dormant, unconnected', ...
%         'dormant, excited 1', 'dormant excited 2', 'dormant, excited jointly', ...
%         'dormant, inhibited 1', 'dormant inhibited 2', ...
%         'dormant, inhibited jointly', 'active, unconnected', ...
%         'active, excited 1', 'active, excited 2', 'active, excited jointly', ...
%         'active, inhibited 1', 'active, inhibited 2', 'active, inhibited jointly'};
    tmatArchetypes = {'null hypothesis', 'dormant, unconnected', ...
        'dormant, excited 1', 'dormant, excited jointly', ...
        'dormant, inhibited 1', ...
        'dormant, inhibited jointly', 'active, unconnected', ...
        'active, excited 1', 'active, excited 2', 'active, excited jointly', ...
        'active, inhibited 1', 'active, inhibited 2', 'active, inhibited jointly'};
    
    em1_guess = [0.7 0.1 0.1 0.1;.1 .7 .1 .1];
    em2_guess = [0.7 0.1 0.1 0.1;.1 .7 .1 .1];
    em3_guess = [0.7 0.1 0.1 0.1;.1 .7 .1 .1];
    tmatBest = 0;
    logLsOld = -99999999;
    connectivities = {};
    logLs = {};

    for i = 1:length(tmatArchetypes)
        tic
        tr1_guess = archetypeLookup3D(tmatArchetypes{i}, 2);
        tr2_guess = archetypeLookup3D(tmatArchetypes{i}, 2);
        tr3_guess = archetypeLookup3D(tmatArchetypes{i}, 2);

        packed_hmm = pack3DHMM(tr1_guess, tr2_guess, tr3_guess, em1_guess, em2_guess, em3_guess);
        [packed_hmm, logLsNew] = baum_welch3d_mod(packed_hmm, n1Spikes+1, n2Spikes+1, n3Spikes+1, true);
        [tr1, tr2, tr3, ~, ~, ~] = unpack3DHMM(packed_hmm);
        
        if max(logLsNew) > logLsOld
            tmatBest = i;
            logLsOld = logLsNew;
            [A_B,A_C,~] = connectivity3d(tr1, tr2, tr3, 0);
            [B_A,B_C,~] = connectivity3d(tr2, tr1, tr3, 0);
            [C_A,C_B,~] = connectivity3d(tr3, tr1, tr2, 0);
            A_B = max(A_B);
            A_C = max(A_C);
            B_A = max(B_A);
            B_C = max(B_C);
            C_A = max(C_A);
            C_B = max(C_B);
        end
        toc
    end
    
    tr1_guess = archetypeLookup3D(tmatArchetypes{tmatBest}, 2);
    tr2_guess = archetypeLookup3D(tmatArchetypes{tmatBest}, 2);
    tr3_guess = archetypeLookup3D(tmatArchetypes{tmatBest}, 2);

    [~, ~, logLs1D_n1] = baum_welch1d(n1Spikes+1, tr1_guess(:,:,1,1), em1_guess);
    [~, ~, logLs1D_n2] = baum_welch1d(n2Spikes+1, tr2_guess(:,:,1,1), em2_guess);
    [~, ~, logLs1D_n3] = baum_welch1d(n3Spikes+1, tr3_guess(:,:,1,1), em3_guess);
    
    if (max(logLs1D_n1)+max(logLs1D_n2)+max(logLs1D_n3) > coef*logLsOld)
        A_B = 0;
        A_C = 0;
        B_A = 0;
        B_C = 0;
        C_A = 0;
        C_B = 0;
    end
    max_connectivities{j} = [A_B, A_C, B_A, B_C, C_A, C_B];
end