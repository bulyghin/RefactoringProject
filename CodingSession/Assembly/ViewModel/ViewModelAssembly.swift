class ViewModelAssembly: DependencyFactory {
    
}

extension ViewModelAssembly: ViewModelAssemblyProtocol {
    
    func mediaViewModel(dataSource: MediaDataSourceProtocol) -> MediaViewModel {
        return scoped(MediaViewModel(dataSource: dataSource)) { [weak self] instance in
            instance.viewModelAssembly = self
            instance.initialize()
        }
    }
    
}
