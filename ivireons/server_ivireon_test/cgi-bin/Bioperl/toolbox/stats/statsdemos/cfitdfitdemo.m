%% Curve Fitting and Distribution Fitting
% "I have some data and I want to fit a Weibull distribution.  What MATLAB(R)
% functions can I use to do Weibull curve fitting?"
%
% Before answering that question, we need to figure out what kind of data
% analysis is really appropriate.  Let's look into the differences between
% curve fitting on the one hand, and modelling data with probability
% distributions on the other.

%   Copyright 2005-2008 The MathWorks, Inc.
%   $Revision: 1.1.8.1 $  $Date: 2010/03/16 00:30:48 $


%% Curve Fitting
% Consider an experiment where we measure the concentration of a compound in
% blood samples taken from several subjects at various times after taking an
% experimental medication.
time = [ 0.1   0.1   0.3   0.3   1.3   1.7   2.1   2.6   3.9   3.9 ...
         5.1   5.6   6.2   6.4   7.7   8.1   8.2   8.9   9.0   9.5 ...
         9.6  10.2  10.3  10.8  11.2  11.2  11.2  11.7  12.1  12.3 ...
        12.3  13.1  13.2  13.4  13.7  14.0  14.3  15.4  16.1  16.1 ...
        16.4  16.4  16.7  16.7  17.5  17.6  18.1  18.5  19.3  19.7];
conc = [0.01  0.08  0.13  0.16  0.55  0.90  1.11  1.62  1.79  1.59 ...
        1.83  1.68  2.09  2.17  2.66  2.08  2.26  1.65  1.70  2.39 ...
        2.08  2.02  1.65  1.96  1.91  1.30  1.62  1.57  1.32  1.56 ...
        1.36  1.05  1.29  1.32  1.20  1.10  0.88  0.63  0.69  0.69 ...
        0.49  0.53  0.42  0.48  0.41  0.27  0.36  0.33  0.17  0.20];
plot(time,conc,'o');
xlabel('Time'); ylabel('Blood Concentration');
%%
% Notice that we have one response variable, blood concentration, and one
% predictor variable, time after ingestion.  The predictor data are assumed to
% be measured with little or no error, while the response data are assumed
% to be affected by experimental error.  The main objective in analyzing data
% like these is often to define a model that predicts the response variable.
% That is, we are trying to describe the trend line, or the mean response of y
% (blood concentration), as a function of x (time).  This is curve fitting
% with bivariate data.
%
% Based on theoretical models of absorption into and breakdown in the
% bloodstream, we might, for example, decide that the concentrations ought to
% follow a Weibull curve as a function of time.  The Weibull curve, which
% takes the form
%
% $$y = c * (x/a)^{(b-1)} * exp(-(x/a)^b),$$
%
% is defined with three parameters: the first scales the curve along the
% horizontal axis, the second defines the shape of the curve, and the third
% scales the curve along the vertical axis.  Notice that while this curve has
% almost the same form as the Weibull probability density function, it is not
% a density because it includes the parameter c, which is necessary to allow
% the curve's height to adjust to data.
%
% We can fit the Weibull model using nonlinear least squares.
modelFun =  @(p,x) p(3) .* (x ./ p(1)).^(p(2)-1) .* exp(-(x ./ p(1)).^p(2));
startingVals = [10 2 5];
coefEsts = nlinfit(time, conc, modelFun, startingVals);
xgrid = linspace(0,20,100);
line(xgrid, modelFun(coefEsts, xgrid), 'Color','r');
%%
% This scatterplot suggests that the measurement errors do not have equal
% variance, but rather, that their variance is proportional to the height of
% the mean curve.  One way to address this problem would be to use weighted
% least squares.  However, there is another potential problem with this fit.
%
% The Weibull curve we're using, as with other similar models such as
% Gaussian, gamma, or exponential curves, is often used as a model when the
% response variable is nonnegative.  Ordinary least squares curve fitting is
% appropriate when the experimental errors are additive and can be considered
% as independent draws from a symmetric distribution, with constant variance.
% However, if that were true, then in this example it would be possible to
% measure negative blood concentrations, which is clearly not reasonable.
%
% It might be more realistic to assume multiplicative errors, symmetric on the
% log scale.  We can fit a Weibull curve to the data under that assumption by
% logging both the concentrations and the original Weibull curve itself.  That
% is, we can use nonlinear least squares to fit the curve
%
% $$log(y) = log(c) + (b-1)*log(x/a) - (x/a)^b.$$
coefEsts2 = nlinfit(time, log(conc), @(p,x)log(modelFun(p,x)), startingVals);
line(xgrid, modelFun(coefEsts2, xgrid), 'Color',[0 .5 0]);
legend({'Raw Data' 'Additive Errors Model' 'Multiplicative Errors Model'});
%%
% This model fit should be accompanied by estimates of precision and followed
% by checks on the model's goodness of fit.  For example, we should make
% residual plots on the log scale to check the assumption of constant variance
% for the multiplicative errors.  For simplicity we'll leave that out here.
%
% In this example, using the multiplicative errors model made little
% difference in the model's predictions, but that's not always the case.  An
% example where it does matter is described in the <xform2lineardemo.html
% Pitfalls in Fitting Nonlinear Models by Transforming to Linearity> demo.


%% Functions for Curve Fitting
% |MATLAB| and several toolboxes contain functions that can used to perform
% curve fitting.  The Statistics Toolbox(TM) includes the functions |nlinfit|, for
% nonlinear least squares curve fitting, and |glmfit|, for fitting Generalized
% Linear Models.  The Curve Fitting Toolbox(TM) provides command line and
% graphical tools that simplify many of the tasks in curve fitting, including
% automatic choice of starting coefficient values for many models, as well as
% providing robust and nonparametric fitting methods.  Many complicated types
% of curve fitting analyses, including models with constraints on the
% coefficients, can be done using functions in the Optimization Toolbox(TM).  The
% |MATLAB| function |polyfit| fits polynomial models, and |fminsearch| can be
% used in many other kinds of curve fitting.


%% Distribution Fitting
% Now consider an experiment where we've measured the time to failure for 50
% identical electrical components.
life = [ 6.2 16.1 16.3 19.0 12.2  8.1  8.8  5.9  7.3  8.2 ...
        16.1 12.8  9.8 11.3  5.1 10.8  6.7  1.2  8.3  2.3 ...
         4.3  2.9 14.8  4.6  3.1 13.6 14.5  5.2  5.7  6.5 ...
         5.3  6.4  3.5 11.4  9.3 12.4 18.3 15.9  4.0 10.4 ...
         8.7  3.0 12.1  3.9  6.5  3.4  8.5  0.9  9.9  7.9];
%%
% Notice that only one variable has been measured -- the components'
% lifetimes. There is no notion of response and predictor variables; rather,
% each observation consists of just a single measurement.  The objective of an
% analysis for data like these is not to predict the lifetime of a new
% component given a value of some other variable, but rather to describe the
% full distribution of possible lifetimes.  This is distribution fitting with
% univariate data.
%
% One simple way to visualize these data is to make a histogram.
binWidth = 2;
binCtrs = 1:binWidth:19;
hist(life,binCtrs);
xlabel('Time to Failure'); ylabel('Frequency'); ylim([0 10]);
%%
% It might be tempting to think of this histogram as a set of (x,y) values,
% where each x is a bin center and each y is a bin height.
h = get(gca,'child');
set(h,'FaceColor',[.98 .98 .98],'EdgeColor',[.94 .94 .94]);
counts = hist(life,binCtrs);
hold on
plot(binCtrs,counts,'o');
hold off
%%
% We might then try to fit a curve through those points to model the data.
% Since lifetime data often follow a Weibull distribution, and we might even
% think to use the Weibull curve from the curve fitting example above.
coefEsts = nlinfit(binCtrs,counts,modelFun,startingVals);
%%
% However, there are some potential pitfalls in fitting a curve to a
% histogram, and this simple fit is not appropriate.  First, the bin counts
% are nonnegative, implying that measurement errors cannot be symmetric.
% Furthermore, the bin counts have different variability in the tails than in
% the center of the distribution.  They also have a fixed sum, implying that
% they are not independent measurements.  These all violate basic assumptions
% of least squares fitting.
%
% It's also important to recognize that the histogram really represents a
% scaled version of an empirical probability density function (PDF).  If we
% fit a Weibull curve to the bar heights, we would have to constrain the curve
% to be properly normalized.
%
% These problems might be addressed by using a more appropriate least squares
% fit.  But another concern is that for continuous data, fitting a model
% based on the histogram bin counts rather than the raw data throws away
% information.  In addition, the bar heights in the histogram are very
% dependent on the choice of bin edges and bin widths.  While it is possible
% to fit distributions in this way, it's usually not the best way.

%%
% For many parametric distributions, maximum likelihood is a much better way
% to estimate parameters.  Maximum likelihood does not suffer from any of the
% problems mentioned above, and it is often the most efficient method in the
% sense that results are as precise as is possible for a given amount of data.
%
% For example, the function |wblfit| uses maximum likelihood to fit a Weibull
% distribution to data.  The Weibull PDF takes the form
%
% $$y = (a/b) * (x/a)^{(b-1)} * exp(-(x/a)^b).$$
%
% Notice that this is almost the same functional form as the Weibull curve
% used in the curve fitting example above.  However, there is no separate
% parameter to independently scale the vertical height.  Being a PDF, the
% function always integrates to 1.
%
% We'll fit the data with a Weibull distribution, then plot a histogram of the
% data, scaled to integrate to 1, and superimpose the fitted PDF.
paramEsts = wblfit(life);
n = length(life);
prob = counts / (n * binWidth);
bar(binCtrs,prob,'hist');
h = get(gca,'child');
set(h,'FaceColor',[.9 .9 .9]);
xlabel('Time to Failure'); ylabel('Probability Density'); ylim([0 0.1]);
xgrid = linspace(0,20,100);
pdfEst = wblpdf(xgrid,paramEsts(1),paramEsts(2));
line(xgrid,pdfEst)
%%
% Maximum likelihood can, in a sense, be thought of as finding a Weibull PDF
% to best match the histogram.  But it is not done by minimizing the sum of
% squared differences between the PDF and the bar heights.
%
% As with the curve fitting example above, this model fit should be
% accompanied by estimates of precision and followed by checks on the model's
% goodness of fit; for simplicity we'll leave that out here.


%% Functions for Distribution Fitting
% The Statistics Toolbox includes functions, such as |wblfit|, for fitting
% many different parametric distributions using maximum likelihood, and the
% function |mle| can be used to fit custom distributions for which dedicated
% fitting functions are not explicitly provided.  The function |ksdensity|
% fits a nonparametric distribution model to data.  The Statistics Toolbox
% also provides the GUI |dfittool|, which simplifies many of the tasks in
% distribution fitting, including generation of various visualizations and
% diagnostic plots.  Many types of complicated distributions, including
% distributions with constraints on the parameters, can be fit using functions
% in the Optimization Toolbox. Finally, the |MATLAB| function |fminsearch| can
% be used in many kinds of maximum likelihood distribution fitting.

%%
% Although fitting a curve to a histogram is usually not optimal, there are
% sensible ways to apply special cases of curve fitting in certain
% distribution fitting contexts.  One method, applied on the cumulative
% probability (CDF) scale instead of the PDF scale, is described in the
% <cdffitdemo.html Fitting a Univariate Distribution Using Cumulative
% Probabilities> demo.


%% Summary
% It's not uncommon to do curve fitting with a model that is a scaled
% version of a common probability density function, such as the Weibull,
% Gaussian, gamma, or exponential.  Curve fitting and distribution fitting can
% be easy to confuse in these cases, but the two are very different kinds of
% data analysis.
%
% * *Curve fitting* involves modelling the trend or mean of a response
% variable as a function of a second predictor variable.  The model usually
% must include a parameter to scale the height of the curve, and may also
% include an intercept term.  The appropriate plot for the data is an x-y
% scatterplot.
%
% * *Distribution fitting* involves modelling the probability distribution of
% a single variable.  The model is a normalized probability density function.
% The appropriate plot for the data is a histogram.


displayEndOfDemoMessage(mfilename)
