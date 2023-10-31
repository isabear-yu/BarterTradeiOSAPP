//
//  RespondTradeView.swift
//  BarterProject
//
//  Created by Claudia Chua on 10/11/21.
//

import SwiftUI

struct RespondTradeView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var trade: Trade
    var tradeViewModel = TradeViewModel()
    let height = UIScreen.main.bounds.height * 0.7
    
    var body: some View {
        
        VStack {
            HStack {
                Text(trade.requestorName).fontWeight(.semibold)
                Text("wants to trade").foregroundColor(.gray)
            }
            Text(trade.requestorItemName).foregroundColor(.shadedColor).fontWeight(.semibold)
            HStack {
                Text("for your").foregroundColor(.gray)
                Text(trade.requesteeItemName).fontWeight(.semibold)
            }
            
        }.frame(height: height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        Spacer()
        HStack {
            
            Button(action: {
                tradeViewModel.changeTradeStatus(trade: trade, response: "Accepted")
                self.mode.wrappedValue.dismiss()
            }) {
                Text("Accept").fontWeight(.semibold).font(.subheadline)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green.opacity(0.7))
            .cornerRadius(40)
            Button(action: {
                tradeViewModel.changeTradeStatus(trade: trade, response: "Rejected")
                self.mode.wrappedValue.dismiss()
            }) {
                Text("Reject").fontWeight(.semibold).font(.subheadline)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.shadedColor.opacity(0.7))
            .cornerRadius(40)
        }
    }
}


