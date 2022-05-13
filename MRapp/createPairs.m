function [f1 f2 t1 delTPoints] = createPairs(peaks,timeBinSec)
%Dimiourgoume zeugaria apo ta peaks enos spectrogram matrix
%kai pairnoume ta peaks san simio tautisis, epita kanoume tautisi 
%ta peaks san simio anaforas me ta prwta numPairsMax pou einai mesa sto
%target zone


    [rowSizeSpec, colSizeSpec] = size(peaks); 
    [rowPeakLoc,colPeakLoc] = find(peaks); 
    numPeaks = length(rowPeakLoc); 

    deltaT = 30;
    deltaF = 15;
    deltaTInit = 5;

    numPairsMax = 5;
    f1=0; 
    f2=0;
    t1=0;
    delTPoints=0;

    for i=1:numPeaks 
        anchorPtRow = rowPeakLoc(i); 
        anchorPtCol = colPeakLoc(i);

        maxDistRight = anchorPtCol+deltaT+deltaTInit;
        maxDistLeft = anchorPtCol + deltaTInit;
        
        if(maxDistRight > colSizeSpec) 
           maxDistRight = colSizeSpec; 
        end
        
        if(maxDistLeft > colSizeSpec) 
           maxDistLeft = colSizeSpec; 
        end
        
        maxDistUp = anchorPtRow+deltaF;
        maxDistDown = anchorPtRow-deltaF;

        if(maxDistDown<1)
           maxDistDown = 1; 
        end
        if(maxDistUp>rowSizeSpec)
           maxDistUp = rowSizeSpec; 
        end

        counter=0; 
 
        for j=maxDistDown:maxDistUp
            for k=anchorPtCol:maxDistRight
                
                if(counter<numPairsMax)
                    
                    for m=1:numPeaks 

                        if( j==rowPeakLoc(m) && k==colPeakLoc(m) ) 

                            if(anchorPtRow == rowPeakLoc(m) && anchorPtCol == colPeakLoc(m) )
                              
                            else
                                
                                
                                if(f1(1)~=0) 
                                    f1(1) = [anchorPtRow];
                                    f2(1) = [rowPeakLoc(m)];
                                    t1(1) = [anchorPtCol.*timeBinSec];
                                    delTPoints(1) = [(colPeakLoc(m) - anchorPtCol).*timeBinSec];
                                else
                                    f1 = [f1, anchorPtRow];
                                    f2 = [f2, rowPeakLoc(m)];
                                    t1 = [t1, anchorPtCol.*timeBinSec];
                                    delTPoints = [delTPoints, (colPeakLoc(m) - anchorPtCol).*timeBinSec];
                                end

                                counter = counter + 1; 

                            end 

                        end 
                    end 

                end 

            end
        end 

    end

end

