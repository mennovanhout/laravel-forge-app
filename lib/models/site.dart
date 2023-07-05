class Site {
  Site(
      this.id,
      this.name,
      this.username,
      this.directory,
      this.wildcards,
      this.status,
      this.repository,
      this.repositoryProvider,
      this.repositoryBranch,
      this.repositoryStatus,
      this.quickDeploy,
      this.projectType,
      this.app,
      this.phpVersion,
      this.appStatus,
      this.slackChannel,
      this.telegramChatId,
      this.telegramChatTitle,
      this.deploymentUrl,
      this.createdAt,
      this.tags);

  int id;
  String name;
  String username;
  String directory;
  bool wildcards;
  String status;
  String? repository;
  String? repositoryProvider;
  String? repositoryBranch;
  String? repositoryStatus;
  bool quickDeploy;
  String projectType;
  String? app;
  String? phpVersion;
  String? appStatus;
  String? slackChannel;
  String? telegramChatId;
  String? telegramChatTitle;
  String deploymentUrl;
  DateTime createdAt;
  List<String> tags;

  static Site fromJson(json) {
    return Site(
        json['id'],
        json['name'],
        json['username'],
        json['directory'],
        json['wildcards'],
        json['status'],
        json['repository'],
        json['repository_provider'],
        json['repository_branch'],
        json['repository_status'],
        json['quick_deploy'],
        json['project_type'],
        json['app'],
        json['php_version'],
        json['app_status'],
        json['slack_channel'],
        json['telegram_chat_id'],
        json['telegram_chat_title'],
        json['deployment_url'],
        DateTime.parse(json['created_at']),
        json['tags'].cast<String>());
  }
}
