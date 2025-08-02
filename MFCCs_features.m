% this script extracts MFCCs features
disp('extracting MFCCs...')

% extract train and test MFCCs
firstGenreTestMFCCs = extract_from_path([pwd,'\data\first_genre\test\'], ...
    ext,WL,SL);
firstGenreTrainMFCCs = extract_from_path([pwd,'\data\first_genre\train\'], ...
    ext,WL,SL);
secondGenreTestMFCCs = extract_from_path([pwd,'\data\second_genre\test\'], ...
    ext,WL,SL);
secondGenreTrainMFCCs = extract_from_path([pwd,'\data\second_genre\train\'], ...
    ext,WL,SL);
thirdGenreTestMFCCs = extract_from_path([pwd,'\data\third_genre\test\'], ...
    ext,WL,SL);
thirdGenreTrainMFCCs = extract_from_path([pwd,'\data\third_genre\train\'], ...
    ext,WL,SL);

% extracting MFCCs for noisy test files
disp('extracting MFCCs from noisy test files...')
firstGenreNoisyTestMFCCs = extract_from_path([pwd,'\data\first_genre\test\noisy\'], ...
    ext,WL,SL);
secondGenreNoisyTestMFCCs = extract_from_path([pwd,'\data\second_genre\test\noisy\'], ...
    ext,WL,SL);
thirdGenreNoisyTestMFCCs = extract_from_path([pwd,'\data\third_genre\test\noisy\'], ...
    ext,WL,SL);

% labels for test, noisy test and train features
labelFirstGenreTestMFCCs = ones(length(firstGenreTestMFCCs),1);
labelSecondGenreTestMFCCs = repmat(2,length(secondGenreTestMFCCs),1);
labelThirdGenreTestMFCCs = repmat(3,length(thirdGenreTestMFCCs),1);
allTestMFCCs = [firstGenreTestMFCCs secondGenreTestMFCCs thirdGenreTestMFCCs];
ground_truth_mfccs = [labelFirstGenreTestMFCCs; labelSecondGenreTestMFCCs; labelThirdGenreTestMFCCs];

labelFirstGenreNoisyTestMFCCs = ones(length(firstGenreNoisyTestMFCCs),1);
labelSecondGenreNoisyTestMFCCs = repmat(2,length(secondGenreNoisyTestMFCCs),1);
labelThirdGenreNoisyTestMFCCs = repmat(3,length(thirdGenreNoisyTestMFCCs),1);
allNoisyTestMFCCs = [firstGenreNoisyTestMFCCs secondGenreNoisyTestMFCCs thirdGenreNoisyTestMFCCs];
ground_truth_noisy_mfccs = [labelFirstGenreNoisyTestMFCCs;
    labelSecondGenreNoisyTestMFCCs; labelThirdGenreNoisyTestMFCCs];

labelFirstGenreTrainMFCCs = ones(length(firstGenreTrainMFCCs),1);
labelSecondGenreTrainMFCCs = repmat(2,length(secondGenreTrainMFCCs),1);
labelThirdGenreTrainMFCCs = repmat(3,length(thirdGenreTrainMFCCs),1);
allTrainMFCCs = [firstGenreTrainMFCCs secondGenreTrainMFCCs thirdGenreTrainMFCCs];
AllLabelsMFCCs = [labelFirstGenreTrainMFCCs; labelSecondGenreTrainMFCCs; labelThirdGenreTrainMFCCs];

% normalization
disp('normalization...')
allTrainMFCCs = allTrainMFCCs';
mn = mean(allTrainMFCCs);
st = std(allTrainMFCCs);
allTrainMFCCs =  (allTrainMFCCs - repmat(mn,size(allTrainMFCCs,1),1))./repmat(st,size(allTrainMFCCs,1),1);

allTestMFCCs = allTestMFCCs';
allTestMFCCs =  (allTestMFCCs - repmat(mn,size(allTestMFCCs,1),1))./repmat(st,size(allTestMFCCs,1),1);

allNoisyTestMFCCs = allNoisyTestMFCCs';
mn = mean(allNoisyTestMFCCs);
st = std(allNoisyTestMFCCs);
allNoisyTestMFCCs =  (allNoisyTestMFCCs - repmat(mn,size(allNoisyTestMFCCs,1),1))./repmat(st,size(allNoisyTestMFCCs,1),1);

test = {allTestMFCCs, allNoisyTestMFCCs};
test_labels = {ground_truth_mfccs, ground_truth_noisy_mfccs};
knn_description = {'kNN-based genre classification(MFCCs)';
    'kNN-based genre classification(MFCCs) adding noise to test set'};
dt_description = {'DT-based genre classification(MFCCs)';
    'DT-based genre classification(MFCCs) adding noise to test set'};
knn_disp_description = {'training kNN (MFCCs)...';
    'training kNN (Noisy MFCCs)...'};
dt_disp_description = {'training DT (MFCCs)...';
    'training DT (Noisy MFCCs)...'};

figure

for j = 1:2
    disp(knn_disp_description{j})
    k=[1 10 20 100 200];
    rate = [];
    for kk=1:length(k)
        % train the kNN
        Mdl_MFCCs = fitcknn(allTrainMFCCs,AllLabelsMFCCs','NumNeighbors',k(kk));

        % test the kNN
        predicted_label_mfccs = predict(Mdl_MFCCs,test{j});

        % measure the performance
        correct = 0;
        for i=1:length(predicted_label_mfccs)
            if predicted_label_mfccs(i)==test_labels{j}(i)
                correct=correct+1;
            end
        end
        %disp('recognition rate:')
        rate(kk) = (correct/length(predicted_label_mfccs))*100;
    end
    [a,b]=max(rate);
    disp('----------results----------------')
    disp(['the maximum recognition rate is ',mat2str(a)])
    disp(['and it is acheived with ',mat2str(k(b)),' nearest neighbors'])

    % train and test the kNN using the best k value
    knn_Mdl_mfccs = fitcknn(allTrainMFCCs,AllLabelsMFCCs','NumNeighbors',(k(b)));
    predicted_label_mfccs = predict(knn_Mdl_mfccs,test{j});

    % plotting
    subplot(2,2,2*j-1)
    Cknn = confusionmat(test_labels{j}, predicted_label_mfccs)
    cmknn = confusionchart(Cknn, {firstGenre  secondGenre  thirdGenre}, ...
        'Title', knn_description{j}, 'RowSummary', 'row-normalized');

    disp(dt_disp_description{j})
    % train the DT
    tree_mfccs = fitctree(allTrainMFCCs,AllLabelsMFCCs);
    % test the DT
    predicted_label_dt_mfccs = predict(tree_mfccs,test{j});

    % plotting
    subplot(2,2,2*j)
    Ctree_MFCCs = confusionmat(test_labels{j}, predicted_label_dt_mfccs)
    cmtree_MFCCs = confusionchart(Ctree_MFCCs, {firstGenre  secondGenre  thirdGenre}, ...
        'Title', dt_description{j}, 'RowSummary', 'row-normalized');
end