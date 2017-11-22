function f = Gauss2d_Error()
    %Gaussian Parameters: meanX,meanY,dispX,dispY,centroid,volume
    Parameters = [14.1375   2.5772   7.3718   0.299171   -0.764614   0.999999;
    7.33541   -0.785791   1.28593   0.179989   -1.46085   1;
    5.54937   -0.866186   0.107892   1.76481   -1.03594   1;
    4.96542   0.00338963   1.70368   0.442596   -0.80207   1;
    11.5473   -0.72469   0.851837   0.969955   -0.155105   1;
    17.1275   1.01237   0.928741   3.49666   -1.16394   1;
    6.09851   0.0119253   0.00711492   0.626672   -0.867381   1;
    13.3501   -0.190298   0.617028   1.0965   -0.474351   1;
    1.948   0.625339   0.270798   1.78489   -1.91664   1;
    1.26283   -0.369367   0.70852   0.740615   -0.410047   1;
    19.6722   -0.110792   1.61971   0.554647   0.110566   1;
    8.91999   -0.582385   0.525911   0.872832   -0.394072   1;
    5.32752   1.00066   2.0202   0.334579   0.835702   1;
    2.26848   3.55243   8.94121   1.23921   1.74341   0.999999;
    18.0946   1.40362   0.895902   1.31557   1.49109   1;
    15.9781   -1.08173   3.85427   1.01349   0.137834   1;
    3.16607   1.35241   2.70857   1.62285   0.735126   0.999999;
    15.7088   1.52393   1.81514   0.968618   1.44734   1;
    11.5679   2.57362   3.35235   0.550063   1.30699   1;
    12.011   1.83346   0.305314   1.64076   2.09453   1;
    14.6271   0.336569   1.26323   0.0151389   2.34157   1;
    8.00394   0.474021   0.267734   2.36824   2.4396   1;
    9.54138   0.523786   0.0276464   1.38318   2.40515   1;
    5.7374   1.52284   0.0379058   0.263007   2.72004   1;
    6.69518   1.47062   0.729832   0.0643401   2.93066   1;
    9.61449   0.802225   0.0863875   0.339661   3.09326   1;
    14.9016   -2.47441   1.32058   0.906101   3.00655   1;
    9.37674   -2.63608   1.90246   0.795775   3.12197   0.999999;
    8.25725   1.37862   0.46199   0.0102838   3.70373   1;
    15.5044   0.897984   0.14603   0.390617   3.79732   1;]
    
    f = zeros(length(Parameters)-1,1);
    for rules_removed = 1:length(Parameters)-1 %take out 1 rule up to 29 rules
        repeatNum = 16;
        for repeat = 1:repeatNum % repeat random rule removal 50 times and 
            %size(Parameters,1)
            tempP = Parameters;
            for taken = 1:rules_removed
               rowSize = size(tempP,1);
               tempP(randi(rowSize,1,'distributed'),:) = [];     
            end
            addpath('/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-2D'); 
            fx = importdata('/Users/kodyferguson/Documents/Papers/Fall 2017 Classes/EE 500/ASAM Experiment/FuzzyApproximation_v1/ASAM-2D/standardized_reduced_dog_data_bounded.dat');
            breed = fx.data(:,1);
            heritage = fx.data(:,2);
            price = fx.data(:,3);
            sum_error = 0.0;
            for i = 1:length(breed)
                approx = Gauss2d_approximation(tempP, breed(i,1), heritage(i,1));
                error = approx - price(i,1);
                sq_error = error * error;
                sum_error = sum_error + sq_error;
            end
            f(rules_removed,1) = f(rules_removed,1) + sqrt(sum_error/length(breed));
        end
    end
    f = f / repeatNum;
end