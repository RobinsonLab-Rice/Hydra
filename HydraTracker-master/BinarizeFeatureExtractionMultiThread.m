function [TrackDir] = BinarizeFeatureExtractionMultiThread(TrackDir)

%Robinson Lab -Krishna Badhiwala (April 2019)
% Process each video in the folder for feature extraction
% Must Run getBehavioralTrackFileList and CreateInitializeFile first
% Binarizes each frame for detecting Hydra and extracts position info
% To Do: optimize foot/mouth classification, posture detection
%(used in behavioral analysis for feature extraction of  hydra)

%
%Input:
%   TrackDir = struct containing file info
%   TrackDir{folder#}.DirPath = folder path string
%   TrackDir{folder#}.FileList = List of video filename within each folder
%   TrackDir{folder#}.FPS = frame rate for the folder (1.0)
%   TrackDir{folder#}.NumHydra = number of Hydra in the folder
%   TrackDir{folder#}.InitilizeFilePath = initialization filepath
%   TrackDir{folder#}.OutputDir = output folder path that contains analyzed
%   hydra data

%output:
% hydra = struct
% TrackDir{foldercount}.HydraFeaturesFile

%Notes:
%   Creates a struct of TrackDir containing file path info for
%   initialization file

    numHydra = TrackDir{1}.NumHydra;
     fps = TrackDir{1}.FPS;
    currpath =  TrackDir{1}.DirPath;
    outputdir = TrackDir{1}.OutputDir;
    
    vidfilenames = TrackDir{1}.FileList;
    InitilizeFilePath = TrackDir{1}.InitilizePath;
    
    % load initialization file if it exists
    if exist(InitilizeFilePath)
        load(InitilizeFilePath);
    else
       Hydra_ROI
    end
    

for hh = 1:numHydra
   
    
    
    % Compressed vid with movement track
    fileoutTrack = strcat(outputdir,'FullTimelapseTracked.mp4');
    vidoutTrack = VideoWriter(fileoutTrack,'MPEG-4');
    vidoutTrack.Quality = 20;
    vidoutTrack.FrameRate = 100;
    open(vidoutTrack);
    
    
    
    frmcntr=0;
    for filecount = 1:numel(vidfilenames)
        %         for filecount = 1:13
        fullfilepath = strcat(currpath, '\', vidfilenames{filecount});
        currVid = VideoReader(fullfilepath);
        
        
        % for each frame in the video detect hydra and behavior properties
        while hasFrame(currVid)
            frmcntr=frmcntr+1
            
            % if prev loc is just one point, add few points before and
            % after to  make sure hydra is captured
            if length(prevHydra(1).X)==1
                for hydraCntr = 1:numHydra
                    prevHydra(hydraCntr).X = (round(prevHydra(hydraCntr).X)-5):(round(prevHydra(hydraCntr).X)+5);
                    prevHydra(hydraCntr).Y = (round(prevHydra(hydraCntr).Y)-5):(round(prevHydra(hydraCntr).Y)+5);
                end
            end
            
            
            currFr = readFrame(currVid);        % frame
            gryfr = 255-rgb2gray(currFr);
            gryfrbck = gryfr;
            
            frtrack = gryfr;
            frtrack(:,:,2)= gryfr;
            frtrack(:,:,3) = gryfr;
            
            
            bwfrsub = gryfr-bckfr;
            bwfrsub(framemask==1)=0;
            
            % try adaptive thresholding later
            bwfrsub = imbinarize(bwfrsub,0.06);
            bwthresh = 0.05;
            
            % Adjust the binary threshold for when frames capture
            % stimulations light artifacts
            while (length(find(bwfrsub==1))>3000)
                
                bwthresh = bwthresh+0.1;
                bwfrsub = gryfr-bckfr;
                bwfrsub(framemask==1)=0;
                bwfrsub = imbinarize(bwfrsub,bwthresh);
            end
            
            
            %bwfrsub = imbinarize(bwfrsub,'adaptive','ForegroundPolarity','bright','Sensitivity',0.2);
            bwfrsub = bwareaopen(bwfrsub,5);
            
            for hydraCntr = 1:numHydra
                hydralocs = combvec(prevHydra(hydraCntr).X,prevHydra(hydraCntr).Y);
                hydralocs = hydralocs';
                %     prevHydra(i).locs = locs;
                
                hydraImg = bwselect(bwfrsub,hydralocs(:,1),hydralocs(:,2));
                hydraImg = bwareafilt(hydraImg,1);
                
                hydra(hydraCntr).Prop = regionprops(hydraImg,'MajorAxisLength','MinorAxisLength','Orientation','Centroid','Extrema');
                
                %TO DO - trying to use adaptive thresholding here ...
                %                 hydrafrMask = zeros(size(bwfrsub),'uint8');
                %                 hydrafrMask(round(hydra(i).Prop.BoundingBox(2)-hydra(i).Prop.BoundingBox(4)):round(hydra(i).Prop.BoundingBox(2)+hydra(i).Prop.BoundingBox(4)),round(hydra(i).Prop.BoundingBox(1)-hydra(i).Prop.BoundingBox(3)):round(hydra(i).Prop.BoundingBox(1)+hydra(i).Prop.BoundingBox(3)))=1;
                %                 bwfrsub2 = gryfr;
                %                 bwfrsub2(hydrafrMask==0) = 0;
                %                 bwfrsub2 = imbinarize(bwfrsub2,'adaptive','ForegroundPolarity','bright');
                hydra(hydraCntr).TrackingError(frmcntr) = 0; % no erros yet
                
                
                % if hydra is not detected then set all properties to
                % values from previous timepoint
                if(isempty(hydra(hydraCntr).Prop))
                    hydra(hydraCntr).TrackingError(frmcntr) = 1; % region prop is empty
%                                         hydra(hydraCntr).Length(frmcntr) = nan;
%                                         hydra(hydraCntr).Orientation(frmcntr) = nan;
%                                         hydra(hydraCntr).Width(frmcntr) = nan;
%                                         hydra(hydraCntr).Center(frmcntr,1:2) = hydra(hydraCntr).Center(frmcntr-1,:);
%                                         hydra(hydraCntr).Skellength(frmcntr) = nan;
%                                         hydra(hydraCntr).SkelPruneLength(frmcntr) = nan;
%                                         hydra(hydraCntr).SklEndpnt1(frmcntr,:) = [nan,nan];
%                                         hydra(hydraCntr).SklEndpnt2(frmcntr,:) = [nan,nan];
%                                         hydra(hydraCntr).foot(frmcntr,:) = [nan,nan];
%                                         hydra(hydraCntr).head(frmcntr,:) = [nan,nan];
                    hydra(hydraCntr).Length(frmcntr) = hydra(hydraCntr).Length(frmcntr-1);
                    hydra(hydraCntr).Orientation(frmcntr) = hydra(hydraCntr).Orientation(frmcntr-1);
                    hydra(hydraCntr).Width(frmcntr) = hydra(hydraCntr).Width(frmcntr-1);
                    hydra(hydraCntr).Center(frmcntr,1:2) = hydra(hydraCntr).Center(frmcntr-1,1:2);
                    hydra(hydraCntr).Skellength(frmcntr) = hydra(hydraCntr).Skellength(frmcntr-1);
                    hydra(hydraCntr).SkelPruneLength(frmcntr) = hydra(hydraCntr).SkelPruneLength(frmcntr-1);
                    hydra(hydraCntr).SklEndpnt1(frmcntr,:) = hydra(hydraCntr).SklEndpnt1(frmcntr-1,:);
                    hydra(hydraCntr).SklEndpnt2(frmcntr,:) = hydra(hydraCntr).SklEndpnt2(frmcntr-1,:);
                    hydra(hydraCntr).foot(frmcntr,:) = hydra(hydraCntr).foot(frmcntr-1,:);
                    hydra(hydraCntr).head(frmcntr,:) = hydra(hydraCntr).head(frmcntr-1,:);
%                    
                    hydra(hydraCntr).FlashStimSeq(frmcntr) = mean2(gryfr);
                    
                    prevHydra(hydraCntr).X = (round(hydra(hydraCntr).Center(frmcntr-1,1))-15):(round(hydra(hydraCntr).Center(frmcntr-1,1))+15);
                    prevHydra(hydraCntr).Y = (round(hydra(hydraCntr).Center(frmcntr-1,2))-15):(round(hydra(hydraCntr).Center(frmcntr-1,2))+15);
                    
                else
                    
                    if(frmcntr>2&&(pdist([(hydra(hydraCntr).Center(frmcntr-1,1:2));hydra(hydraCntr).Prop.Centroid])>50))
                        hydra(hydraCntr).Length(frmcntr) = hydra(hydraCntr).Length(frmcntr-1);
                        hydra(hydraCntr).Orientation(frmcntr) = hydra(hydraCntr).Orientation(frmcntr-1);
                        hydra(hydraCntr).Width(frmcntr) = hydra(hydraCntr).Width(frmcntr-1);
                        hydra(hydraCntr).Center(frmcntr,1:2) = hydra(hydraCntr).Center(frmcntr-1,1:2);
                        hydra(hydraCntr).Skellength(frmcntr) = hydra(hydraCntr).Skellength(frmcntr-1);
                        hydra(hydraCntr).SkelPruneLength(frmcntr) = hydra(hydraCntr).SkelPruneLength(frmcntr-1);
                        hydra(hydraCntr).SklEndpnt1(frmcntr,:) = hydra(hydraCntr).SklEndpnt1(frmcntr-1,:);
                        hydra(hydraCntr).SklEndpnt2(frmcntr,:) = hydra(hydraCntr).SklEndpnt2(frmcntr-1,:);
                        hydra(hydraCntr).foot(frmcntr,:) = hydra(hydraCntr).foot(frmcntr-1,:);
                        hydra(hydraCntr).head(frmcntr,:) = hydra(hydraCntr).head(frmcntr-1,:);
                        
                        hydra(hydraCntr).FlashStimSeq(frmcntr) = mean2(gryfr);
                        
                        prevHydra(hydraCntr).X = (round(hydra(hydraCntr).Center(frmcntr,1))-15):(round(hydra(hydraCntr).Center(frmcntr,1))+15);
                        prevHydra(hydraCntr).Y = (round(hydra(hydraCntr).Center(frmcntr,2))-15):(round(hydra(hydraCntr).Center(frmcntr,2))+15);
                        
                        hydra(hydraCntr).TrackingError(frmcntr) = 2; % center moved was too large 
                    else
                        
                        % for the first frame head/foot loc = set by user
                        % during initializatipn
                        if (frmcntr==1)
                            prevSkelEndpnt1(hydraCntr).X = prevEndpnt1(hydraCntr).X;
                            prevSkelEndpnt1(hydraCntr).Y = prevEndpnt1(hydraCntr).Y;
                            prevSkelEndpnt2(hydraCntr).X = prevEndpnt2(hydraCntr).X;
                            prevSkelEndpnt2(hydraCntr).Y = prevEndpnt2(hydraCntr).Y;
                            prevfoot(hydraCntr,:) = [prevEndpnt1(hydraCntr).X,prevEndpnt1(hydraCntr).Y];
                            prevhead(hydraCntr,:) = [prevEndpnt2(hydraCntr).X,prevEndpnt2(hydraCntr).Y];
                            
                        end
                        %                     [hydra(i).RegEndpnt1(frmcntr,:),hydra(i).RegEndpnt2(frmcntr,:)] = MeanExtremaPnts(hydra(i).Prop);
                        
                        
                        [currfoot(hydraCntr,:),currhead(hydraCntr,:),~] = getFootPos(hydraImg,gryfr,hydra(hydraCntr).Prop,prevfoot(hydraCntr,:),prevhead(hydraCntr,:));
                        
                        
                        
                        if frmcntr<51
                            meanprevfoot = prevfoot(hydraCntr,:);
                        else
                            meanprevfoot = mean(hydra(hydraCntr).foot(frmcntr-20:frmcntr-1,:));
                        end
                             %     if ((pdist([prevfoot;currhead])<pdist([prevfoot;currfoot]))&&(pdist([prevhead;currhead])>pdist([prevhead;currfoot])))
                        if (pdist([meanprevfoot;currhead(hydraCntr,:)])<pdist([meanprevfoot;currfoot(hydraCntr,:)]))
                            
                            tempfoot = currfoot(hydraCntr,:);
                            currfoot(hydraCntr,:) = currhead(hydraCntr,:);
                            currhead(hydraCntr,:) = tempfoot;
                        end
                        
                        
                        prevfoot(hydraCntr,:) = round(currfoot(hydraCntr,:));
                        prevhead(hydraCntr,:) = round(currhead(hydraCntr,:));
                        
                        
                        hydraImg = bwmorph(hydraImg,'fill');
                        bwskfr = bwmorph(hydraImg,'thin',Inf);
                        
                        bwendpnts = bwmorph(bwskfr,'endpoints');
                        [r,c] = find(bwendpnts);
                        
                        if (length(r)~=2)
                            hydraImg = imfill(hydraImg,'holes');
                            bwskfr = bwmorph(hydraImg,'thin',Inf);
                            bwendpnts = bwmorph(bwskfr,'endpoints');
                        end
                        
                        
                        
                        hydra(hydraCntr).Skellength(frmcntr) = length(find(bwskfr==1));
                        
                        if(hydra(hydraCntr).Skellength(frmcntr)>1)
                            [bwskpfr,~] = longestConstrainedPath(bwskfr,'thinOpt','Thin');
                            hydra(hydraCntr).SkelPruneLength(frmcntr) = length(find(bwskpfr==1));
                            bwendpnts = bwmorph(bwskpfr,'endpoints');
                            [c,r] = find(bwendpnts);
                            %                         hydra(i).endpnt1(frmcntr,:) = [r(1),c(1)];
                            %                         hydra(i).endpnt2(frmcntr,:)= [r(2),c(2)];
                            
                            if((pdist([r(1),c(1);prevSkelEndpnt1(hydraCntr).X,prevSkelEndpnt1(hydraCntr).Y]))<(pdist([r(1),c(1);prevSkelEndpnt2(hydraCntr).X,prevSkelEndpnt2(hydraCntr).Y])))
                                hydra(hydraCntr).SklEndpnt1(frmcntr,:) = [r(1),c(1)];
                                hydra(hydraCntr).SklEndpnt2(frmcntr,:)= [r(2),c(2)];
                            else
                                hydra(hydraCntr).SklEndpnt2(frmcntr,:) = [r(1),c(1)];
                                hydra(hydraCntr).SklEndpnt1(frmcntr,:)= [r(2),c(2)];
                            end
                            prevSkelEndpnt1(hydraCntr).X = hydra(hydraCntr).SklEndpnt1(frmcntr,1);
                            prevSkelEndpnt1(hydraCntr).Y = hydra(hydraCntr).SklEndpnt1(frmcntr,2);
                            prevSkelEndpnt2(hydraCntr).X = hydra(hydraCntr).SklEndpnt2(frmcntr,1);
                            prevSkelEndpnt2(hydraCntr).Y = hydra(hydraCntr).SklEndpnt2(frmcntr,2);
                        else
                            hydra(hydraCntr).SkelPruneLength(frmcntr) = nan;
                            [c,r] = find(bwendpnts);
                            hydra(hydraCntr).SklEndpnt1(frmcntr,:) = [r(1),c(1)];
                            hydra(hydraCntr).SklEndpnt2(frmcntr,:)= [r(1),c(1)];
                        end
                        
                        hydra(hydraCntr).FlashStimSeq(frmcntr) = mean2(gryfr);
                        hydra(hydraCntr).Length(frmcntr) = hydra(hydraCntr).Prop.MajorAxisLength;
                        hydra(hydraCntr).Orientation(frmcntr) = hydra(hydraCntr).Prop.Orientation;
                        hydra(hydraCntr).Width(frmcntr) = hydra(hydraCntr).Prop.MinorAxisLength;
                        hydra(hydraCntr).Center(frmcntr,:) = hydra(hydraCntr).Prop.Centroid;
                        hydra(hydraCntr).foot(frmcntr,:) = currfoot(hydraCntr,:);
                        hydra(hydraCntr).head(frmcntr,:) = currhead(hydraCntr,:);
                        prevHydra(hydraCntr).X = (round(hydra(hydraCntr).Center(frmcntr,1))-15):(round(hydra(hydraCntr).Center(frmcntr,1))+15);
                        prevHydra(hydraCntr).Y = (round(hydra(hydraCntr).Center(frmcntr,2))-15):(round(hydra(hydraCntr).Center(frmcntr,2))+15);
                        
                    end
                    if(hydra(hydraCntr).TrackingError(frmcntr)==1)
                    frtrack = insertShape(frtrack,'Circle',[hydra(hydraCntr).Center(frmcntr-1,:),4],'LineWidth',4,'Color','white','opacity',0.9);

                    else
                    frtrack = insertShape(frtrack,'Circle',[hydra(hydraCntr).Center(frmcntr,:),4],'LineWidth',4,'Color','blue','opacity',0.9);
                    frtrack = insertShape(frtrack,'Circle',[hydra(hydraCntr).foot(frmcntr,:),3],'LineWidth',3,'Color','red','opacity',0.9);
                    frtrack = insertShape(frtrack,'FilledCircle',[hydra(hydraCntr).head(frmcntr,:),2],'LineWidth',3,'Color','red','opacity',0.7);
                    end
                    
                    %             hydrabckmask = zeros(size(gryfr),'logical');
                    %             hydrabckmask(round(hydra(i).Prop.BoundingBox(2)-hydra(i).Prop.BoundingBox(4)):round(hydra(i).Prop.BoundingBox(2)+hydra(i).Prop.BoundingBox(4)),round(hydra(i).Prop.BoundingBox(1)-hydra(i).Prop.BoundingBox(3)):round(hydra(i).Prop.BoundingBox(1)+hydra(i).Prop.BoundingBox(3)))=1;
                    if(mod(frmcntr,5000)==0)
                        
                        se = strel('line',15,90);
                        hydraImg = imdilate(hydraImg,se);
                        se = strel('line',15,0);
                        hydraImg = imdilate(hydraImg,se);
                        gryfrbck = regionfill(gryfrbck,hydraImg);
                        bckfr = gryfrbck;
                    end
                end
                
            end
%             imshow(frtrack)
%             pause(0.1)
            writeVideo(vidoutTrack,[currFr;frtrack]);
        end
        
        savefile = strcat(outputdir,'timelapsedata.mat');
        save(savefile,'currpath','hydra','fps');
        
    end
    %     close(vidout);
    close(vidoutTrack);
    
    savefile = strcat(outputdir,'timelapsedata.mat');
    TrackDir{foldercount}.HydraFeaturesFile = savefile;
    save(savefile,'currpath','hydra','fps');
    %     catch ME
    %         close(vidoutTrack);
    %         savefile = strcat(outputdir,'timelapsedata.mat');
    %         TrackDir{foldercount}.HydraFeaturesFile = savefile;
    %         save(savefile,'currpath','hydra','fps');
    %         TrackDir{foldercount}.Error = ME.Identifier;
    %     end
    
    %%
    for hydraCntr=1:numHydra
        
        nanLenInd = find(isnan(hydra(hydraCntr).SkelPruneLength));
        hydra(hydraCntr).SkelPruneLength(nanLenInd) = hydra(hydraCntr).Length(nanLenInd);
        
        
        t=(1:(frmcntr))./(fps*3600);
        figure;
        ax(1) = subplot(4,1,1);
        plot(t,hydra(hydraCntr).Length)
        ax(2) = subplot(4,1,2);
        plot(t,hydra(hydraCntr).Skellength,'r')
        hold on
        plot(t,hydra(hydraCntr).SkelPruneLength,'g')
        title(strcat('length',num2str(hydraCntr)))
        ax(3)=subplot(4,1,3);
        plot(t,hydra(hydraCntr).Orientation)
        title('orientation')
        ax(4) = subplot(4,1,4);
        plot(t,hydra(hydraCntr).Width)
        title('width')
        % xlim(ax,[0 12])
        outfile = strcat(outputdir,'Hydra',num2str(hydraCntr),'plot.pdf');
        print('-painters', '-dpdf', '-r1200',outfile);
        
        HydraContractions(hydraCntr).locs = ContractionRate(hydra(hydraCntr).Skellength,fps);
        outfile = strcat(outputdir,'Hydra',num2str(hydraCntr),'ContractionsPlot.pdf');
        print('-painters', '-dpdf', '-r1200',outfile);
        %
        %         HydraContractions(i).locs = ContractionRate(hydra(i).Skellength(24*3600:36*3600),fps);
        %         outfile = strcat(outputdir,'Hydra',num2str(i),'ContractionsPlot24.pdf');
        %         print('-painters', '-dpdf', '-r1200',outfile);
        
        %         HydraContractions(i).locs = ContractionRate(hydra(i).Skellength(60*3600:72*3600),fps);
        %         outfile = strcat(outputdir,'Hydra',num2str(i),'ContractionsPlot60.pdf');
        %         print('-painters', '-dpdf', '-r1200',outfile);
        %         k = k+1;
        
    end
    
    
    %%
end