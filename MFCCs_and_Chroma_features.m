% this script trains and tests both kNN and DT by combining
% both MFCCs and Chroma features altogether
disp('combining MFCCs and Chroma features...')

% combining features
allTest = [allTestMFCCs allTestChroma];
allNoisyTest = [allNoisyTestMFCCs allNoisyTestChroma];
allTrain = [allTrainMFCCs allTrainChroma];

% labels for test, noisy test and train features
labelFirstGenreTrainAll = ones(length([firstGenreTrainMFCCs; firstGenreTrainChroma]),1);
labelSecondGenreTrainAll = repmat(2,length([secondGenreTrainMFCCs; secondGenreTrainChroma]),1);
labelThirdGenreTrainAll = repmat(3,length([thirdGenreTrainMFCCs; thirdGenreTrainChroma]),1);
allLabels = [labelFirstGenreTrainAll; labelSecondGenreTrainAll; labelThirdGenreTrainAll];

labelFirstGenreTestAll = ones(length([firstGenreTestMFCCs; firstGenreTestChroma]),1);
labelSecondGenreTestAll = repmat(2,length([secondGenreTestMFCCs; secondGenreTestChroma]),1);
labelThirdGenreTestAll = repmat(3,length([thirdGenreTestMFCCs; thirdGenreTestChroma]),1);
ground_truth = [labelFirstGenreTestAll; labelSecondGenreTestAll; labelThirdGenreTestAll];

labelFirstGenreNoisyTestAll = ones(length([firstGenreNoisyTestMFCCs; ...
    firstGenreNoisyTestChroma]),1);
labelSecondGenreNoisyTestAll = repmat(2,length([secondGenreNoisyTestMFCCs; ...
    secondGenreNoisyTestChroma]),1);
labelThirdGenreNoisyTestAll = repmat(3,length([thirdGenreNoisyTestMFCCs; ...
    thirdGenreNoisyTestChroma]),1);
ground_truth_noisy = [labelFirstGenreNoisyTestAll; labelSecondGenreNoisyTestAll; labelThirdGenreNoisyTestAll];

% normalization
disp('normalization...')

mn = mean(allTrain);
st = std(allTrain);
allTrain =  (allTrain - repmat(mn,size(allTrain,1),1))./repmat(st,size(allTrain,1),1);

mn = mean(allTest);
st = std(allTest);
allTest =  (allTest - repmat(mn,size(allTest,1),1))./repmat(st,size(allTest,1),1);

mn = mean(allNoisyTest);
st = std(allNoisyTest);
allNoisyTest =  (allNoisyTest - repmat(mn,size(allNoisyTest,1),1))./repmat(st,size(allNoisyTest,1),1);

test = {allTest, allNoisyTest};
test_labels = {ground_truth, ground_truth_noisy};
knn_description = {'kNN-based genre classification(Chroma + MFCCs)';
    'kNN-based genre classification(Chroma + MFCCs) adding noise to test set'};
dt_description = {'DT-based genre classification(Chroma + MFCCs)';
    'DT-based genre classification(Chroma + MFCCs) adding noise to test set'};
knn_disp_description = {'training kNN (Chroma + MFCCs)...';
    'training kNN (Noisy Chroma + MFCCs)...'};
dt_disp_description = {'training DT (Chroma + MFCCs)...';
    'training DT (Noisy Chroma + MFCCs)...'};

figure

for j = 1:2
    disp(knn_disp_description{j})
    k=[1 10 20 100];
    rate = [];
    for kk=1:length(k)
        % train the kNN
        Mdl = fitcknn(allTrain,allLabels','NumNeighbors',k(kk));

        % test the kNN
        predicted_label = predict(Mdl,test{j});

        % measure the performance
        correct = 0;
        for i=1:length(predicted_label)
            if predicted_label(i)==test_labels{j}(i)
                correct=correct+1;
            end
        end
        %disp('recognition rate:')
        rate(kk) = (correct/length(predicted_label))*100;
    end
    [a,b]=max(rate);
    disp('----------results----------------')
    disp(['the maximum recognition rate is ',mat2str(a)])
    disp(['and it is acheived with ',mat2str(k(b)),' nearest neighbors'])

    % train and test the kNN using the best k value
    knn_Mdl = fitcknn(allTrain,allLabels','NumNeighbors',(k(b)));
    predicted_label = predict(knn_Mdl,test{j});

    % plotting
    subplot(2,2,2*j-1)
    Cknn = confusionmat(test_labels{j}, predicted_label)
    cmknn = confusionchart(Cknn, {firstGenre  secondGenre  thirdGenre}, ...
        'Title', knn_description{j}, 'RowSummary', 'row-normalized');

    disp(dt_disp_description{j})
    % train the DT
    tree = fitctree(allTrain,allLabels);
    % test the DT
    predicted_label_dt = predict(tree,test{j});

    % plotting
    subplot(2,2,2*j)
    Ctree = confusionmat(test_labels{j}, predicted_label_dt)
    cmtree_chroma = confusionchart(Ctree, {firstGenre  secondGenre  thirdGenre}, ...
        'Title', dt_description{j}, 'RowSummary', 'row-normalized');
end