enum TabItem {
  home,
  match,
  account,
}

const tabItemToIndex = {
  TabItem.home: 0,
  TabItem.match: 1,
  TabItem.account: 2,
};

const indexToTabItem = {
  0: TabItem.home,
  1: TabItem.match,
  2: TabItem.account,
};
