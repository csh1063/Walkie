//
//  BaseProvider.swift
//  Walkie
//
//  Created by sanghyeon on 7/5/25.
//

import Moya

public final class BaseProvider<U: TargetType>: MoyaProvider<U> {
    
    public init(
        endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
        stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
        plugins: [PluginType] = []
    ) {
        let session = Moya.Session()
        var refreshPlugins = plugins
        refreshPlugins.append(MoyaLoggingPlugin())
//        refreshPlugins.append(RefreshTokenPlugin())
        super.init(session: session, plugins: refreshPlugins)
    }
}
