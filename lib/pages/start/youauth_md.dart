import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/util/md_history.dart';

class MdServiceItem {
  final String name;
  final String prefix;
  final bool useNacos;
  final String? target;
  final String? serviceName;
  final String? group;
  final String? scheme;

  MdServiceItem({
    required this.name,
    required this.prefix,
    required this.useNacos,
    this.target,
    this.serviceName,
    this.group,
    this.scheme,
  });

  factory MdServiceItem.fromJson(Map<String, dynamic> json) {
    return MdServiceItem(
      name: json['name'] ?? '',
      prefix: json['prefix'] ?? '',
      useNacos: json['useNacos'] == true,
      target: json['target'],
      serviceName: json['serviceName'],
      group: json['group'],
      scheme: json['scheme'],
    );
  }
}

class MdLoginPage extends StatefulWidget {
  const MdLoginPage({Key? key}) : super(key: key);
  @override
  State<MdLoginPage> createState() => _MdLoginPageState();
}

class _MdLoginPageState extends State<MdLoginPage> {
  final TextEditingController _mdUrlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio();
  bool _loading = false;
  String? _mdBaseUrl;
  String? _mdToken;
  List<MdServiceItem> _services = [];
  List<MdServiceHistory> _history = [];

  String _normalizeBaseUrl(String input) {
    String trimmed = input.trim();
    if (trimmed.isEmpty) return trimmed;
    if (!trimmed.contains('://')) {
      trimmed = 'http://' + trimmed;
    }
    Uri uri;
    try {
      uri = Uri.parse(trimmed);
    } catch (_) {
      return trimmed;
    }
    String scheme = uri.scheme.isEmpty ? 'http' : uri.scheme;
    String host = uri.host.isEmpty ? uri.path : uri.host;
    int port = uri.hasPort ? uri.port : 8802;
    final normalized = Uri(scheme: scheme, host: host, port: port).toString();
    return normalized;
  }

  String _joinBaseAndPrefix(String base, String prefix) {
    String b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    String p = prefix.startsWith('/') ? prefix : ('/' + prefix);
    return b + p;
  }

  Future<void> _fetchServices() async {
    final md = _mdBaseUrl;
    if (md == null || md.isEmpty) return;
    final resp = await _dio.get(
      "$md/api/service/list",
      options: Options(
        headers: _mdToken == null || _mdToken!.isEmpty
            ? null
            : {"Authorization": "Bearer $_mdToken"},
      ),
    );
    if (resp.data is Map && resp.data['data'] is List) {
      final List list = resp.data['data'];
      _services = list
          .map((e) => MdServiceItem.fromJson(e))
          .where((e) => (e.name.toString().toLowerCase()).contains('comic'))
          .toList()
          .cast<MdServiceItem>();
      // 如果只有一个服务，自动选择并返回
      if (_services.length == 1) {
        await _selectService(_services.first);
        return;
      }
      setState(() {});
    }
  }

  Future<void> _loadHistory() async {
    await MdServiceHistoryManager().refreshHistory();
    setState(() {
      _history = MdServiceHistoryManager().list;
    });
  }

  Future<void> _loginMd() async {
    final md = _normalizeBaseUrl(_mdUrlController.text.trim());
    if (md.isEmpty) return;
    setState(() {
      _loading = true;
    });
    try {
      final resp = await _dio.post(
        "$md/api/oauth/youauth/password",
        data: {
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
        },
      );
      if (resp.data is Map && resp.data['success'] == true) {
        final token = resp.data['data']?['accessToken'] ?? '';
        _mdBaseUrl = md;
        _mdToken = token;
        await _fetchServices();
      }
    } finally {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  Future<void> _selectService(MdServiceItem item) async {
    final md = _mdBaseUrl;
    if (md == null) return;
    final String baseUrl = _joinBaseAndPrefix(md, item.prefix);
    ApiClient().baseUrl = baseUrl;
    ApiClient().token = _mdToken ?? "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiUrl', baseUrl);
    await prefs.setString('sign', _mdToken ?? "");
    await MdServiceHistoryManager().add(
      MdServiceHistory(
        mdUrl: md,
        name: item.name,
        prefix: item.prefix,
        mdToken: _mdToken,
      ),
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MediaDashboard 登录与服务选择')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _mdUrlController,
              decoration: const InputDecoration(
                labelText: 'MediaDashboard URL (例如 http://host:8802)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: '用户名'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '密码'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _loginMd,
                child: Text(_loading ? '登录中...' : '登录 MediaDashboard'),
              ),
            ),
            const SizedBox(height: 16),
            const Text('历史（点按快速选择）：'),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: FutureBuilder(
                future: _loadHistory(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final h = _history[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text('${h.name}@${h.mdUrl}${h.prefix}'),
                          onPressed: () async {
                            ApiClient().baseUrl =
                                _joinBaseAndPrefix(h.mdUrl, h.prefix);
                            ApiClient().token = h.mdToken ?? "";
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('apiUrl',
                                _joinBaseAndPrefix(h.mdUrl, h.prefix));
                            await prefs.setString('sign', h.mdToken ?? "");
                            if (mounted) Navigator.of(context).pop(true);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            const Text('可用服务（登录后加载）：'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final item = _services[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text('prefix: ${item.prefix}'),
                      onTap: () => _selectService(item),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
