//
//  ListConversationViewModel.swift
//  ThueNha
//
//  Created by LTD on 12/9/18.
//  Copyright (c) 2018 Skynet Software. All rights reserved.
//

import UIKit

struct ListConversation {

    struct Request {
        var idUser: Int
        var type: Int
        
        struct DeleteConversation {
            var idPost: String
            var idUser: String
            var idHost: String
        }
        
        struct ConfirnRent {
            var idPost: String
            var idUser: String
            var idHost: String
        }
        
    }
    
    struct Response {
        var listConversation: ListConversationResponseModel?
        var error: Error?
    }
    
    struct ViewModel {
        
        struct DisplayedTable {
            var sections: [DisplayedSection]
            
            init(sections: [DisplayedSection] = []) {
                self.sections = sections
            }
        }
        
        struct DisplayedSection {
            var cells: [DisplayedCell]
            
            init(cells: [DisplayedCell] = []) {
                self.cells = cells
            }
        }
        
        struct DisplayedCell {
            var conversation: ConversationModel?
        }
        
        var displayedTable: DisplayedTable?
        
    }
}
