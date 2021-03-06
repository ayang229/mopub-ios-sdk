//
//  MenuDataSource.swift
//
//  Copyright 2018-2019 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import UIKit

class MenuDataSource {
    // MARK: - Properties
    
    /**
     Ordered section titles
     */
    private(set) var sections: [String] = [] {
        didSet {
            sections.sort()
        }
    }
    
    /**
     Internal data sources for each menu grouping
     */
    fileprivate var sources: [String: MenuDisplayable] = [:]
    
    // MARK: - Initialization
    
    init() {
        add(menu: LogingLevelMenuDataSource())
    }
    
    // MARK: - Data Source
    
    /**
     Adds a new menu and its associated data source if it doesn't already exist.
     - Parameter menu: Menu item to add.
     */
    func add(menu: MenuDisplayable) {
        guard !sections.contains(menu.title) else {
            return
        }
        
        sections.append(menu.title)
        sources[menu.title] = menu
    }
    
    // MARK: - Accessors
    
    func cell(forIndexPath indexPath: IndexPath, inTableView tableView: UITableView) -> UITableViewCell {
        guard let cell = sources[sections[indexPath.section]]?.cell(forItem: indexPath.row, inTableView: tableView) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func items(forSection index: Int) -> Int {
        return sources[sections[index]]?.count ?? 0
    }
    
    func didSelect(itemAtIndexPath indexPath: IndexPath, inTableView tableView: UITableView, presentingFrom viewController: UIViewController) -> Bool {
        let canSelect = sources[sections[indexPath.section]]?.canSelect(itemAt: indexPath.row, inTableView: tableView) ?? false
        if canSelect {
            sources[sections[indexPath.section]]?.didSelect(itemAt: indexPath.row, inTableView: tableView, presentFrom: viewController)
        }
        
        return canSelect
    }
}
