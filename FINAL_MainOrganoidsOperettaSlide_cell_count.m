%% User inputs

clear
clc

SetupMode = 0; % 1 for creating numeric organoid labels OR 0 for linking the final analysis to human labels
SlideLayout = 'DAN2017_04';

SavePath = 'S:\HCS_Platform\Data\SilviaBolognin\Operetta\ORGANOIDS_Lisa\DopaPhenotype with cell count\Rerun\DAN2017_04';
mkdir(SavePath)
f_LogDependencies(mfilename, 'S:\HCS_Platform\Data\SilviaBolognin\Operetta\ORGANOIDS_Lisa\DopaPhenotype with cell count\Rerun\code')
%PreviewSavePath = 'S:\HCS_Platform\Data\SilviaBolognin\OperettaBeginnings\Previews';
PreviewSavePath = [SavePath, filesep, 'Previews'];
mkdir(PreviewSavePath)

%% Parallel pool control
delete(gcp('nocreate'))
myCluster = parcluster;
Workers = myCluster.NumWorkers;
% parpool(28) %for HURRICANE
parpool(Workers) % for MEGATRON

%% Run mode control
if SetupMode
    RunMode = 0;
else
    RunMode = 1;
end

%% Common part

    channelID = 1; % channel to use for overview
    
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20170928_C08_p7-p10_20170718\5acf261f-0e37-46c3-bc43-df70ac5197ce\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20170919_CO8_p4-p5-p6_20170825\5066bda5-9082-4b05-bbdd-6718b58c22cb\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20170918_BILL_p4-p5-p6_20170825\c37cde94-2234-4ae2-8d5a-b63054f30a85\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20170920_BILL_p7-p10_20170718\c6acb02c-4aef-4c4e-aae1-7bddff39fe92\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20171005_BILLWT-MutP4-5-6\f26dd9ec-b0d1-40b4-a4d4-8d9c6e27464f\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20171016_IM5GC-Mut_20171006_DAN\006a4466-c449-4d47-adb1-ff2fb59a8de5\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20171018_T46GC-Mut_20171006_DAN\b887163d-8332-4e99-860e-925b58e747d5\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20171018_A13WT-Mut_20171006_DAN\be8efc6e-5b5e-4615-b4b8-44e7f229d6a9\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180215_DAN2018_01\022c26c6-0d44-4acc-9810-121d364468a2\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180215_DAN2018_09\feebaa78-61c6-462b-89df-bda2b3b27d26\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180216_DAN2018_02\c05c78ed-da82-4c0f-a6b9-2ff013322388\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180219_DAN2018_01\cf8f04db-1cf3-4613-9083-1ea40cea2704\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\DAN2017_03\9b1d8735-5018-42ac-9d18-821afa372105\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20170920_BILL_p7-p10_20170718\c6acb02c-4aef-4c4e-aae1-7bddff39fe92\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20171005_BILLWT-MutP4-5-6\f26dd9ec-b0d1-40b4-a4d4-8d9c6e27464f\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180216_DAN2018_03\c41ef7ca-fb79-4602-a9b3-5d3d81008449\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180219_DAN2018_04\f8137ab9-2f4e-4842-86ee-82872c92caae\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180220_DAN2018_05\e5d023a9-7696-4b66-a6d5-7388c2bca8e8\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\SN_030418_Hoechst_K7WT_C6000THMAP2FOXA2\71eb8c0b-8e78-44a5-8514-fe2719aa448c\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180221_DAN2018_07\662fba81-4ef1-4e54-bd97-597abec9ba03\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180222_DAN2018_08\256ee1b4-9d1b-43ea-8367-bad31a5e0cb5\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180220_DAN2018_06\adcbbe97-9046-427b-a70b-d388bc763bd7\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180215_DAN2018_09\feebaa78-61c6-462b-89df-bda2b3b27d26\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180608_DAN2018_12\2ac39c1b-9a0e-4eff-81b2-54a39d09ef02\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180608_DAN2018_13\85fa8886-4a8a-437f-93cf-f89497ea10ec\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180612_DAN2018_14\d44633f7-ac4d-461b-97b8-dcea12926a36\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180620_DAN2018_17\dcfe50ba-4575-4d09-bb92-4e78c03c9559\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180620_DAN2018_16\4d97ef23-365d-40cd-bc98-317f5b69e48d\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180620_DAN2018_19\9a97d80e-e29b-47a7-817e-f11f632deab8\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180608_DAN2018_11\a0b15ca5-9d98-4386-8488-f870283621ad\metadata.csv'); %did not work
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180613_DAN2018_11\ec1bc0c4-3f6e-4752-a0ab-10a7c21da3fc\metadata.csv'); %re-acquired, analysis did not work
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180620_DAN2018_11a\d0adafa1-0d16-442e-adac-cf75520a941e\metadata.csv'); %re-acquired single row, analysis did not work
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180621_DAN2018_11e\387e954f-65fd-4fcf-966e-8d39438b9bc7\metadata.csv'); %re-acquired single row, analysis worked!
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180621_DAN2018_11b\0bf6125e-25c5-489d-9bc6-9221488c1302\metadata.csv'); %re-acquired single row, analysis did not work
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180621_DAN2018_11f\53ad2236-d05c-4c84-85d8-a71641e2163c\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180621_DAN2018_18\53a770b9-779b-4623-8190-b3320806316b\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180621_DAN2018_11b\926e3d3b-f298-4e1a-8c3b-6a51f017254e\metadata.csv'); ContainsX0
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180621_DAN2018_15\386f27ee-f653-463f-bf6c-f7dcbb204713\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180625_DAN2018_20\58121660-f9f0-48eb-ac75-287247cf8cc8\metadata.csv');

% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180608_DAN2018_12\2ac39c1b-9a0e-4eff-81b2-54a39d09ef02\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180621_DAN2018_15\386f27ee-f653-463f-bf6c-f7dcbb204713\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180620_DAN2018_16\4d97ef23-365d-40cd-bc98-317f5b69e48d\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180608_DAN2018_13\85fa8886-4a8a-437f-93cf-f89497ea10ec\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180608_DAN2018_12\2ac39c1b-9a0e-4eff-81b2-54a39d09ef02\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180222_DAN2018_08\256ee1b4-9d1b-43ea-8367-bad31a5e0cb5\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180221_DAN2018_07\662fba81-4ef1-4e54-bd97-597abec9ba03\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180220_DAN2018_05\e5d023a9-7696-4b66-a6d5-7388c2bca8e8\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20180216_DAN2018_02\c05c78ed-da82-4c0f-a6b9-2ff013322388\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20170920_BILL_p7-p10_20170718\c6acb02c-4aef-4c4e-aae1-7bddff39fe92\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20171016_IM5GC-Mut_20171006_DAN\006a4466-c449-4d47-adb1-ff2fb59a8de5\metadata.csv');
% InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20170919_CO8_p4-p5-p6_20170825\5066bda5-9082-4b05-bbdd-6718b58c22cb\metadata.csv');
InfoTable = readtable('S:\Operetta\OperettaDB_LCSB\LS_20170918_BILL_p4-p5-p6_20170825\c37cde94-2234-4ae2-8d5a-b63054f30a85\metadata.csv');

    ChannelNames = unique(InfoTable.Channel);
    Channels = length(unique(InfoTable.Channel));
    Planes = unique(InfoTable.Plane)';
    Timepoints = unique(InfoTable.Timepoint)' + 1;
    [GroupsTable, GroupsIm5DCellArray] = FindGroups(InfoTable); % it(GroupsTable)
    
%% Setup mode

if SetupMode == 1
    
    Preview = CreateLabelHelpPreview(GroupsTable, PreviewSavePath);
    imwrite(Preview, [PreviewSavePath, filesep, 'layout.png'])
    Message = ['The plate Layout has been saved at ', [PreviewSavePath, filesep, 'layout.png'], '. Please save a text file without header, using tab separation, where the first column is the index number as shown in the preview and the second is the area name. Save the text file as SlideLayout_Date.txt in your working directory and set the variable SetupMode to 0 >>> Run'];
    h = msgbox(Message);
    
else    
%% Analysis mode
    
    % Load annotations
    Layout = readtable(SlideLayout)
    Layout.Properties.VariableNames = {'Idx', 'AreaName'};
    
    % Load images and organize in an XYC array
    Groups = unique(GroupsTable(GroupsTable > 0))';
    GroupPreviews = {};
    ObjectsAll = {};

    for g = Groups % Number of organoids
    %for g = 1:2 % Number of organoids
    %for g = 7:11 % Number of organoids
        XYMosaicCells = {};
        GroupZone = GroupsTable == g;
        [GroupIdxRowVec, GroupIdxColVec] = find(GroupZone); % linear indexes
        Elements = sum(GroupZone(:));
        InfoTablesThisGroup = {};
        for e = 1:Elements % Fields of a given organoid
            for c = 1:Channels
            InfoTableThisField = GroupsIm5DCellArray{GroupIdxRowVec(e), GroupIdxColVec(e)};
            InfoTablesThisGroup{e} = InfoTableThisField;
            InfoTableThisChannel = InfoTableThisField(strcmp(InfoTableThisField.Channel, ChannelNames{c}), :);
                clear Im4D
                for t = Timepoints
                    for p = Planes
                        InfoTableThisChannelThisPlane = InfoTableThisChannel(InfoTableThisChannel.Plane == p, :);
                        ImPathThisPlane = InfoTableThisChannelThisPlane.Path{:};   
                        Im4D(:,:,t,p) = imread(ImPathThisPlane); % it(Im4D(:,:,t,p))
                    end
                end
               XYMosaicCells{c}{GroupIdxRowVec(e), GroupIdxColVec(e)} = Im4D; % Operetta counterpart of XYmosaicCells for Opera
            end
        end

        InfoTableThisGroup = vertcat(InfoTablesThisGroup{:});

        %% Remove empty cells
        XYMosaicCells = cellfun(@(x) GroupClipper(x),  XYMosaicCells, 'UniformOutput', false);

        %% Stitch
        XYmosaicContourCell = cellfun(@(x) stdfilt(x, ones(3)), XYMosaicCells{1}, 'UniformOutput', false);
        XPositions = unique(InfoTableThisGroup.PositionX); % m
        YPositions = unique(InfoTableThisGroup.PositionY); % m
        ResolutionXY = 675 / 1360; % um per pixel
        MaxPixelDrift = 30;
        PreviewChannel = 1;
        ShowProgress = 0;
        [CroppedMosaic, StitchedIm] = f_stitching_operetta(XYMosaicCells, XYmosaicContourCell, XPositions, YPositions, ResolutionXY, MaxPixelDrift, PreviewChannel, ShowProgress);
        GroupPreviews{g} = max(CroppedMosaic{channelID},[],3); %it(GroupPreviews{g})
        
        %% Image analysis
        Label = Layout(g,:);
         try
            ObjectsThisOrganoid = FINAL_f_ImageAnalysisPerOperettaOrganoid_cell_count(Label, CroppedMosaic{1}, CroppedMosaic{2}, CroppedMosaic{3}, ChannelNames, PreviewSavePath);
        catch
             Errors{g} = 'Image analysis failed';
             continue % next group g
         end
            ObjectsAll{g} = ObjectsThisOrganoid;

    end
    
    Objects = vertcat(ObjectsAll{:});
    save([SavePath, filesep, 'Objects.mat'], 'Objects');
    writetable(Objects, [SavePath, filesep, 'Objects.csv'])
    writetable(Objects, [SavePath, filesep, 'Objects.xlsx'])

    %% Preview of the whole slide

    SizeSingleIm = size(XYMosaicCells{1}{1,1});
    SizeSingleIm = SizeSingleIm(1:2);
    RescanGridSize = size(GroupsTable);
    GreatPreview = zeros(SizeSingleIm(1)*RescanGridSize(1), SizeSingleIm(2)*RescanGridSize(2), 'uint16');
    ImHeight = SizeSingleIm(1);
    ImWidth = SizeSingleIm(2);
    StartRCell = {};
    StartCCell = {};

    for g = Groups
        g
        StitchedGroupSize = size(GroupPreviews{g});
        ZoneNow = GroupsTable == g;
        [R,C] = find(ZoneNow)
        StartR = min(R);
        StartC = min(C);
        StartRPixel = ((StartR-1) * ImHeight) + 1;
        %EndRPixel = StartRPixel + (3 * ImHeight) - 1;
        EndRPixel = StartRPixel + StitchedGroupSize(1) - 1;
        StartCPixel = ((StartC-1) * ImWidth) + 1;
        %EndCPixel = StartCPixel + (3 * ImWidth) - 1;
        EndCPixel = StartCPixel + StitchedGroupSize(2) - 1;
        GreatPreview(StartRPixel:EndRPixel, StartCPixel:EndCPixel) = GroupPreviews{g};
        StartRCell{g} = StartRPixel;
        StartCCell{g} = StartCPixel;
    end

    Zoomfactor = 50;
    %GreatPreviewResized = imresize(imadjust(GreatPreview), 1/Zoomfactor);
    GreatPreviewResized = imresize(imadjust(GreatPreview, [0 0.02], [0 1]), 1/Zoomfactor);

    for g = Groups
        GreatPreviewResized = insertText(GreatPreviewResized, [round(StartCCell{g}/Zoomfactor), round(StartRCell{g}/Zoomfactor)], num2str(g), 'FontSize', 12, 'BoxColor', 'red', 'TextColor', 'white');
    end
    
    %imtool(GreatPreview)
    %imtool(GreatPreviewResized)
    imwrite(GreatPreviewResized, [SavePath, filesep, 'GreatPreview.png'])
    
    % it(GreatPreviewResized)
    % save([SavePath, filesep, 'WorkspaceIncludingObjects.mat'])
    
end




