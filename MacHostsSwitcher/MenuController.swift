//
//  MenuController.swift
//  MacHostsSwitcher
//
//  Created by Eldar on 16/04/2018.
//  Copyright © 2018 thedp. All rights reserved.
//

import Cocoa

struct MenuItemModel {
    var title: String
}

class MenuController: NSObject, NSMenuDelegate {
    @IBOutlet var menu: NSMenu!
    let menuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var modelItemsData: [MenuItemModel]?
    
    override func awakeFromNib() {
        modelItemsData = [MenuItemModel(title: "QA"), MenuItemModel(title: "PROD")]  // TODO: debug - remove
        
        setupMenu()
        setupMenuItems()
        setupDefaultItem()
    }
    
    fileprivate func setupDefaultItem() {
        guard let data = modelItemsData else { return }
        setMenuTitle(data[0].title)
    }
    
    fileprivate func setupMenuItems() {
        guard let data = modelItemsData else { return }
        for (index, model) in data.enumerated() {
            createMenuItem(fromModel: model, withTag: index)
        }
    }
    
    fileprivate func createMenuItem(fromModel model: MenuItemModel, withTag tag: Int?) {
        let tagString = (tag == nil) ? "" : String(tag!)
        let item = NSMenuItem(title: model.title, action: #selector(menuItemPressed(sender:)), keyEquivalent: tagString)
        if let tag = tag { item.tag = tag }
        menu.addItem(item)
    }
    
    fileprivate func setupMenu() {
        setMenuTitle("")
        menuItem.menu = menu
    }
    
    @objc func menuItemPressed(sender: NSMenuItem) {
        setMenuTitle(sender.title)
    }
    
    fileprivate func setMenuTitle(_ title: String) {
        menuItem.title = title
    }
}
