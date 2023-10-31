//
//  RequestDetailView.swift
//  BarterProject
//
//  Created by Claudia Chua on 16/11/21.
//

import SwiftUI

struct RequestDetailView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var trade: Trade
    var tradeViewModel = TradeViewModel()
    let height = UIScreen.main.bounds.height * 0.7
    
    var body: some View {
        
        VStack {
            HStack {
                Text("You want to trade").foregroundColor(.gray).fontWeight(.semibold)
            }
            HStack {
                Text(trade.requestorItemName).fontWeight(.bold).foregroundColor(.gray)
            }
            Text("for").foregroundColor(.gray).fontWeight(.semibold)
            HStack {
                Text(trade.requesteeName).fontWeight(.bold).foregroundColor(.shadedColor)
            }
            HStack {
                Text(trade.requesteeItemName).fontWeight(.bold).foregroundColor(.shadedColor)
            }
        }
        .frame(height: height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        Spacer()
        Button(action: {
            self.tradeViewModel.changeTradeStatus(trade: trade, response: "Cancelled")
            self.mode.wrappedValue.dismiss()
        }) {
            Text("Cancel Trade").fontWeight(.semibold).font(.subheadline)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.shadedColor.opacity(0.7))
        .cornerRadius(40)
    }
    
}
