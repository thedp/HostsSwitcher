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

class Hosts {
    let hostsFile = URL(fileURLWithPath: "/etc/hosts")
    var availableFiles = [URL]()

    init() {
        collectAvailableFiles()
    }

    func setActive(byIndex index: Int) {
        guard availableFiles.count > index else { return }
        try? FileManager.default.copyItem(at: availableFiles[index], to: hostsFile)
    }

    func getName(forIndex index: Int) -> String? {
        guard availableFiles.count > index else { return "" }
        let parts = availableFiles[index].absoluteString.split(separator: Character("_"))
        return String(describing: parts.last ?? "")
    }

    private func collectAvailableFiles() {  // TODO: incomplete
        availableFiles = [URL(fileURLWithPath: "/etc/hosts__QA"),
                          URL(fileURLWithPath: "/etc/hosts__PROD")
        ]  // TODO: debug - remove
    }
}

class MenuController: NSObject, NSMenuDelegate {
    @IBOutlet var menu: NSMenu!
    let menuItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var modelItemsData: [MenuItemModel]?
    var hosts: Hosts?
    
    override func awakeFromNib() {
        setupDataSource()
        setupMenu()
        setupMenuItems()
        setupDefaultItem()
    }
    
    fileprivate func setupDataSource() {
        hosts = Hosts()
        guard let files = hosts?.availableFiles else { return }
        modelItemsData = [MenuItemModel]()
        for (index, _) in files.enumerated() {
            guard let title = hosts?.getName(forIndex: index) else { continue }
            modelItemsData?.append(MenuItemModel(title: title))
        }
    }

    fileprivate func setupDefaultItem() {
        guard let data = modelItemsData, data.count > 0 else { return }
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
        menuItem.title = "~\(title)~"
    }
}
