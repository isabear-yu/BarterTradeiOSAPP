//
//  TradePageView.swift
//  BarterProject
//
//  Created by Claudia Chua on 6/11/21.
//

import SwiftUI

struct TradePageView: View {
    
    var currentUser: User
    @ObservedObject var tradeViewModel = TradeViewModel()
    @State var seeTradeHistory: Bool = false
    let height = UIScreen.main.bounds.height * 0.7
    let headerHeight = UIScreen.main.bounds.height * 0.15
    
    var body: some View {
        
        HStack{
            Image("trade1")
            Text("Trade")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.shadedColor)
            Text("Status")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Spacer()
            Button("History") {
                self.seeTradeHistory = true
            }.sheet(isPresented: $seeTradeHistory, content: {
                TradeHistoryView(currentUser: currentUser)
            })
        }
        .frame(height: headerHeight)
        
        // TabView
        TabView {
            List(tradeViewModel.requesteePendingTrade,id: \.self) { trade in
                VStack(alignment: .leading) {
                    NavigationLink(destination: RespondTradeView(trade: trade)) {
                        Text(trade.requestorItemName)
                            .foregroundColor(Color.shadedColor)
                            .fontWeight(.semibold)
                            .padding(.leading)
                        Text("for: " + trade.requesteeItemName)
                            .padding(.trailing)
                            .foregroundColor(.gray)
                    }
                }
                .padding(10)
                .background(lightGreyColor)
                .modifier(CardModifier())
                .padding(.all, 5)
            }
            .tabItem {
                Label("Trade Request", systemImage: "person.fill")
            }
            .padding(.bottom, -5)
            .background(Color.white)
            
            List(tradeViewModel.requestorPendingTrade,id: \.self) { trade in
                VStack(alignment: .leading) {
                    NavigationLink(destination: RequestDetailView(trade: trade)) {
                        HStack {
                            Text(trade.requesteeItemName).font(.headline)
                                .foregroundColor(Color.shadedColor)
                                .fontWeight(.semibold)
                                .padding(.leading)
                            Text(trade.status)
                                .padding(.trailing)
                                .foregroundColor(.gray)
                        }
                        Text("for : " + trade.requestorItemName).foregroundColor(.gray)
                    }
                }
                .padding(10)
                .background(lightGreyColor)
                .modifier(CardModifier())
                .padding(.all, 5)
            }
            .tabItem {
                Label("My Trade", systemImage: "heart.fill")
            }
            .padding(.bottom, -5)
            .background(Color.white)
        }
        .padding(.bottom, 0)
        .frame(height: height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.white)
        .onAppear {
            self.tradeViewModel.subscribe(currentUser: self.currentUser)
            self.tradeViewModel.getPendingRequesteeTrade(userid: currentUser.id!) { (trades) in
                if trades != nil {
                    DispatchQueue.main.async {
                        tradeViewModel.requesteePendingTrade = trades!
                    }
                }
            }
            
            self.tradeViewModel.getPendingRequestorTrade(userid: currentUser.id!) { (trades) in
                if trades != nil {
                    DispatchQueue.main.async {
                        tradeViewModel.requestorPendingTrade = trades!
                    }
                }
            }
        }

        MenuView(currentUser: currentUser, currentView: "trade")
    }
    
}

//struct TradePageBar: View {
//    var body: some View {
//        HStack{
//            Image("trade1")
//                .padding(.bottom,5)
//            Text("Trade")
//                .font(.title)
//                .fontWeight(.semibold)
//                .padding(.bottom,5)
//                .foregroundColor(.shadedColor)
//            Text("Status")
//                .font(.title)
//                .fontWeight(.semibold)
//                .padding(.bottom,5)
//                .foregroundColor(.gray)
//        }
//        .padding(.horizontal)
//        .padding(.top)
//    }
//}
