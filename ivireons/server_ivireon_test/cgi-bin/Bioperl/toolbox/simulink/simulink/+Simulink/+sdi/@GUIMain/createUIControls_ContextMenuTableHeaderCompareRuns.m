function createUIControls_ContextMenuTableHeaderCompareRuns(this)

%   Copyright 2010 The MathWorks, Inc.

    this.tableColumnSelectContextMenuCompareRuns = uicontextmenu('parent',...
                                                                 this.HDialog);
    this.contextMenuBlkSrc_CompRuns  = uimenu(this.tableColumnSelectContextMenuCompareRuns,...
                                              'label', this.sd.IGBlockSourceColName);
 
    this.contextMenuBlkSrc_CompRuns1  = uimenu(this.contextMenuBlkSrc_CompRuns,...
                                              'label', this.sd.mgRun1BlkSrc);
    this.contextMenuBlkSrc_CompRuns2  = uimenu(this.contextMenuBlkSrc_CompRuns,...
                                              'label', this.sd.mgRun2BlkSrc);
                                          
                                          
    this.contextMenuDataSrc_CompRuns  = uimenu(this.tableColumnSelectContextMenuCompareRuns,...
                                              'label', this.sd.IGDataSourceColName); 
    this.contextMenuDataSrc_CompRuns1  = uimenu(this.contextMenuDataSrc_CompRuns,...
                                              'label', this.sd.mgRun1DataSrc);
    this.contextMenuDataSrc_CompRuns2  = uimenu(this.contextMenuDataSrc_CompRuns,...
                                              'label', this.sd.mgRun2DataSrc);
        
    this.contextMenuSID_CompRuns  = uimenu(this.tableColumnSelectContextMenuCompareRuns,...
                                           'label', this.sd.mgSID);
 
    this.contextMenuSID_CompRuns1  = uimenu(this.contextMenuSID_CompRuns,...
                                            'label', this.sd.mgRun1SID);
    this.contextMenuSID_CompRuns2  = uimenu(this.contextMenuSID_CompRuns,...
                                            'label', this.sd.mgRun2SID); 
    this.contextMenuAbsTol_CompRuns  = uimenu                                       ...
                                     (this.tableColumnSelectContextMenuCompareRuns, ...
                                     'label',                                       ...
                                     this.sd.MGAbsTolLbl);
    this.contextMenuRelTol_CompRuns  = uimenu                                       ...
                                     (this.tableColumnSelectContextMenuCompareRuns, ...
                                     'label',                                      ...
                                     this.sd.MGRelTolLbl);                                 
    this.contextMenuSync_CompRuns  = uimenu                                      ...
                                   (this.tableColumnSelectContextMenuCompareRuns,...
                                   'label',                                      ...
                                   this.sd.MGSynchMethodLbl);                                        
    this.contextMenuInterp_CompRuns  = uimenu                                    ...
                                   (this.tableColumnSelectContextMenuCompareRuns,...
                                   'label',                                      ...
                                   this.sd.MGInterpMethodLbl);     
    this.contextMenuChannel_CompRuns  = uimenu                                   ...
                                   (this.tableColumnSelectContextMenuCompareRuns,...
                                   'label',                                      ...
                                   this.sd.mgChannel1);                                  
                                    
                                          
  
    set(this.contextMenuBlkSrc_CompRuns1, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuBlkSrc_CompRuns2, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuDataSrc_CompRuns1, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuDataSrc_CompRuns2, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuSID_CompRuns1, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuSID_CompRuns2, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuAbsTol_CompRuns, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuRelTol_CompRuns, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuSync_CompRuns, 'callback',...
        @this.tableContextMenu_CompRuns);
    set(this.contextMenuInterp_CompRuns, 'callback',...
        @this.tableContextMenu_CompRuns);   
    set(this.contextMenuChannel_CompRuns, 'callback',...
        @this.tableContextMenu_CompRuns);   
end

