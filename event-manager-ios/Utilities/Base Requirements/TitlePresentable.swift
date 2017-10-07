//
//  TitlePresentable.swift
//  event-manager-ios
//
//  Created by Eszenyi Gábor on 2017. 10. 07..
//  Copyright © 2017. Gabor Eszenyi. All rights reserved.
//

/// This protool will automatically added to UITableView section headers and footers by MV[C]VM templates if needed.
protocol TitlePresentable: Bindable {
    var title: String! { get set }
}
