import ProjectDescription

// command line 입력 --name 파라미터에 들어가는 값
// ex) tuist scaffold jake --name1 hihi
let nameAttribute: Template.Attribute = .required("name")
let orgAttribute: Template.Attribute = .optional("org", default: "sanghyeon")

let template = Template(
    description: "my template",
    attributes: [
        nameAttribute
    ],
    items: [
        .file(
            path: "README.md",
            templatePath: "stencil/README.stencil"
        ),
        .file(
            path: "Project.swift",
            templatePath: "stencil/Project.stencil"
        ),
        .file(
            path: "Tuist.swift",
            templatePath: "stencil/Tuist.stencil"
        ),
        .file(
            path: "Tuist/Package.swift",
            templatePath: "stencil/Tuist/Package.stencil"
        ),
        .file(
            path: "App/Sources/AppDelegate.swift",
            templatePath: "stencil/App/Sources/AppDelegate.stencil"
        ),
        .file(
            path: "App/Sources/SceneDelegate.swift",
            templatePath: "stencil/App/Sources/SceneDelegate.stencil"
        ),
        .file(
            path: "App/Sources/{{name}}App.swift",
            templatePath: "stencil/App/Sources/App.stencil"
        ),
        .file(
            path: "App/Sources/View/MainView.swift",
            templatePath: "stencil/App/Sources/MainView.stencil"
        ),
        .file(
            path: "App/Resources/Assets.xcassets/Contents.json",
            templatePath: "stencil/App/Resources/Asset.stencil"
        ),
        .file(
            path: "App/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json",
            templatePath: "stencil/App/Resources/Asset.stencil"
        )
    ]
)

