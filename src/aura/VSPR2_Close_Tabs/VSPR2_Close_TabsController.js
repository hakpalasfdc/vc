({
  closeTabs: function (cmp, evt, hlp) {
    const workspaceAPI = cmp.find("workspace");
    const closedPinned = cmp.get('v.closePinned');

    const isConsoleNavPromise = workspaceAPI.isConsoleNavigation();
    const allTabPromise = workspaceAPI.getAllTabInfo();


    Promise.all([isConsoleNavPromise, allTabPromise]).then((values) => {

      const isConsole = values[0];
      if (!isConsole) return; 

      const allTabs = values[1]; 
      return Promise.all(hlp.dispatchTabs(workspaceAPI, allTabs, closedPinned)).then(() => allTabs);

    }).then((tabs) => {
      const firstTabId = tabs[0].tabId;

      Promise.all([hlp.focusTab(workspaceAPI, firstTabId), hlp.refreshTab(workspaceAPI, firstTabId)]);
    });
  },
})