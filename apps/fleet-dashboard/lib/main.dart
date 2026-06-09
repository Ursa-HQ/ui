/// Fleet Dashboard — real-time Hermes agent monitoring.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ── Data Models ──────────────────────────────────────────────────

class FleetStatus {
  final List<AgentStatus> agents;
  final SystemStatus systems;

  FleetStatus({required this.agents, required this.systems});

  factory FleetStatus.fromJson(Map<String, dynamic> j) => FleetStatus(
        agents: (j['agents'] as List?)?.map((a) => AgentStatus.fromJson(a)).toList() ?? [],
        systems: SystemStatus.fromJson(j['systems'] ?? {}),
      );
}

class AgentStatus {
  final String name;
  final ContainerInfo container;
  final AgentConfig? config;
  final int sessionCount24h;
  final SessionSummary? lastSession;
  final List<CronTask> cronTasks;
  final String state;
  final List<SessionSummary> sessions24h;

  AgentStatus({
    required this.name,
    required this.container,
    this.config,
    required this.sessionCount24h,
    this.lastSession,
    required this.cronTasks,
    required this.state,
    required this.sessions24h,
  });

  factory AgentStatus.fromJson(Map<String, dynamic> j) => AgentStatus(
        name: j['name'] ?? '',
        container: ContainerInfo.fromJson(j['container'] ?? {}),
        config: j['config'] != null ? AgentConfig.fromJson(j['config']) : null,
        sessionCount24h: j['session_count_24h'] ?? 0,
        lastSession: j['last_session'] != null ? SessionSummary.fromJson(j['last_session']) : null,
        cronTasks: (j['cron_tasks'] as List?)?.map((c) => CronTask.fromJson(c)).toList() ?? [],
        state: j['state'] ?? 'inactive',
        sessions24h: (j['sessions_24h'] as List?)?.map((s) => SessionSummary.fromJson(s)).toList() ?? [],
      );

  Color get healthColor {
    switch (state) {
      case 'ok':
        return const Color(0xFF3FB950);
      case 'stale':
        return const Color(0xFFD29922);
      case 'inactive':
        return const Color(0xFF8B949E);
      case 'error':
        return const Color(0xFFF85149);
      default:
        return const Color(0xFF8B949E);
    }
  }

  String get healthLabel {
    switch (state) {
      case 'ok':
        return '● OK';
      case 'stale':
        return '● Stale';
      case 'inactive':
        return '○ Inactive';
      case 'error':
        return '● Error';
      default:
        return '○ Unknown';
    }
  }
}

class ContainerInfo {
  final bool running;
  final String status;
  final double uptimeSecs;
  final int restartCount;
  final double cpuPercent;
  final double memUsageMb;
  final double memLimitMb;

  ContainerInfo({
    required this.running,
    required this.status,
    required this.uptimeSecs,
    required this.restartCount,
    required this.cpuPercent,
    required this.memUsageMb,
    required this.memLimitMb,
  });

  factory ContainerInfo.fromJson(Map<String, dynamic> j) => ContainerInfo(
        running: j['running'] ?? false,
        status: j['status'] ?? '',
        uptimeSecs: (j['uptime_secs'] ?? 0).toDouble(),
        restartCount: (j['restart_count'] ?? 0).toInt(),
        cpuPercent: (j['cpu_percent'] ?? 0).toDouble(),
        memUsageMb: (j['mem_usage_mb'] ?? 0).toDouble(),
        memLimitMb: (j['mem_limit_mb'] ?? 0).toDouble(),
      );

  String get uptimeFormatted {
    final h = (uptimeSecs ~/ 3600).toInt();
    final m = ((uptimeSecs % 3600) ~/ 60).toInt();
    if (h > 24) {
      return '${h ~/ 24}d ${h % 24}h';
    }
    return '${h}h ${m}m';
  }

  String get memFormatted => '${memUsageMb.toStringAsFixed(0)}MB / ${memLimitMb.toStringAsFixed(0)}MB';
}

class AgentConfig {
  final String model;
  final double? temperature;
  final String cwd;
  final int maxTurns;
  final String platform;

  AgentConfig({
    required this.model,
    this.temperature,
    required this.cwd,
    required this.maxTurns,
    required this.platform,
  });

  factory AgentConfig.fromJson(Map<String, dynamic> j) => AgentConfig(
        model: j['model'] ?? '',
        temperature: (j['temperature'] as num?)?.toDouble(),
        cwd: j['cwd'] ?? '',
        maxTurns: (j['max_turns'] ?? 150).toInt(),
        platform: j['platform'] ?? '',
      );
}

class SessionSummary {
  final String sessionId;
  final String startedAt;
  final String? endedAt;
  final double durationSecs;
  final int messageCount;
  final int toolCallCount;
  final int inputTokens;
  final int outputTokens;
  final double estimatedCost;
  final String model;
  final String? title;

  SessionSummary({
    required this.sessionId,
    required this.startedAt,
    this.endedAt,
    required this.durationSecs,
    required this.messageCount,
    required this.toolCallCount,
    required this.inputTokens,
    required this.outputTokens,
    required this.estimatedCost,
    required this.model,
    this.title,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> j) => SessionSummary(
        sessionId: j['session_id'] ?? '',
        startedAt: j['started_at'] ?? '',
        endedAt: j['ended_at'],
        durationSecs: (j['duration_secs'] ?? 0).toDouble(),
        messageCount: (j['message_count'] ?? 0).toInt(),
        toolCallCount: (j['tool_call_count'] ?? 0).toInt(),
        inputTokens: (j['input_tokens'] ?? 0).toInt(),
        outputTokens: (j['output_tokens'] ?? 0).toInt(),
        estimatedCost: (j['estimated_cost'] ?? 0).toDouble(),
        model: j['model'] ?? '',
        title: j['title'],
      );
}

class CronTask {
  final String id;
  final String name;
  final String schedule;
  final String description;

  CronTask({required this.id, required this.name, required this.schedule, required this.description});

  factory CronTask.fromJson(Map<String, dynamic> j) => CronTask(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        schedule: j['schedule'] ?? '',
        description: j['description'] ?? '',
      );
}

class SystemStatus {
  final List<dynamic> containers;
  final List<dynamic> gpu;
  final List<dynamic> git;
  final List<dynamic> drift;

  SystemStatus({required this.containers, required this.gpu, required this.git, required this.drift});

  factory SystemStatus.fromJson(Map<String, dynamic> j) => SystemStatus(
        containers: j['containers'] ?? [],
        gpu: j['gpu'] ?? [],
        git: j['git'] ?? [],
        drift: j['drift'] ?? [],
      );
}

class AgentDetail {
  final AgentStatus agent;
  final List<SessionSummary> recentSessions;
  final String? configYaml;
  final String? soulMd;

  AgentDetail({required this.agent, required this.recentSessions, this.configYaml, this.soulMd});

  factory AgentDetail.fromJson(Map<String, dynamic> j) => AgentDetail(
        agent: AgentStatus.fromJson(j['agent']),
        recentSessions: (j['recent_sessions'] as List?)?.map((s) => SessionSummary.fromJson(s)).toList() ?? [],
        configYaml: j['config_yaml'],
        soulMd: j['soul_md'],
      );
}

// ── API Service ──────────────────────────────────────────────────

class FleetApi {
  static const _base = '/api/fleet';

  static Future<FleetStatus> getStatus() async {
    final res = await http.get(Uri.parse('$_base/status'));
    return FleetStatus.fromJson(jsonDecode(res.body));
  }

  static Future<AgentDetail> getAgent(String name) async {
    final res = await http.get(Uri.parse('$_base/agent/$name'));
    return AgentDetail.fromJson(jsonDecode(res.body));
  }
}

// ── App ──────────────────────────────────────────────────────────

void main() => runApp(const FleetDashboardApp());

class FleetDashboardApp extends StatelessWidget {
  const FleetDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleet Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        cardColor: const Color(0xFF161B22),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF58A6FF),
          secondary: Color(0xFF3FB950),
        ),
      ),
      home: const FleetPage(),
    );
  }
}

// ── Fleet Dashboard Page ────────────────────────────────────────

class FleetPage extends StatefulWidget {
  const FleetPage({super.key});

  @override
  State<FleetPage> createState() => _FleetPageState();
}

class _FleetPageState extends State<FleetPage> {
  FleetStatus? _status;
  bool _error = false;
  String _errorMsg = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetch();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _fetch());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetch() async {
    try {
      final s = await FleetApi.getStatus();
      setState(() {
        _status = s;
        _error = false;
      });
    } catch (e) {
      if (!_error) {
        setState(() {
          _error = true;
          _errorMsg = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('Fleet Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_status != null)
            Text('${_status!.agents.length} agents',
                style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.grey),
            onPressed: _fetch,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetch,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text('API unreachable\n$_errorMsg',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      );
    }
    if (_status == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Agent grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.85,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _status!.agents.length,
          itemBuilder: (_, i) => _AgentCard(
            agent: _status!.agents[i],
            onTap: () => _openAgentDetail(_status!.agents[i].name),
          ),
        ),
        const SizedBox(height: 16),

        // Systems section
        _sectionHeader('System Status'),
        const SizedBox(height: 8),
        _buildSystemCards(),

        const SizedBox(height: 16),

        if (_status!.systems.git.isNotEmpty) ...[
          _sectionHeader('Git Repos'),
          const SizedBox(height: 8),
          ..._status!.systems.git.map((g) => _GitCard(g)),
        ],
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white));
  }

  Widget _buildSystemCards() {
    final s = _status!.systems;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _systemChip('Containers', '${s.containers.length}', Icons.dns, Colors.blueAccent),
        _systemChip('GPU', '${s.gpu.length}', Icons.memory, Colors.greenAccent),
        _systemChip('Drift Events', '${s.drift.length}', Icons.trending_up, Colors.amberAccent),
      ],
    );
  }

  Widget _systemChip(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text(label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }

  void _openAgentDetail(String name) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AgentDetailPage(agentName: name)),
    );
  }
}

// ── Agent Card ───────────────────────────────────────────────────

class _AgentCard extends StatelessWidget {
  final AgentStatus agent;
  final VoidCallback onTap;

  const _AgentCard({required this.agent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: agent.healthColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: agent.healthColor,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    agent.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (agent.config != null)
              Text(agent.config!.model,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400])),
            const Spacer(),
            Row(
              children: [
                if (agent.container.running)
                  Text(
                    '${agent.container.cpuPercent.toStringAsFixed(1)}% CPU',
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                const Spacer(),
                Text(
                  agent.healthLabel,
                  style: TextStyle(fontSize: 10, color: agent.healthColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Agent Detail Page ───────────────────────────────────────────

class AgentDetailPage extends StatefulWidget {
  final String agentName;
  const AgentDetailPage({super.key, required this.agentName});

  @override
  State<AgentDetailPage> createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage> {
  AgentDetail? _detail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final d = await FleetApi.getAgent(widget.agentName);
      setState(() {
        _detail = d;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: Text(widget.agentName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _detail == null
              ? const Center(child: Text('Failed to load'))
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    // Status banner
                    _infoRow('State', _detail!.agent.healthLabel,
                        color: _detail!.agent.healthColor),
                    _infoRow('Container',
                        _detail!.agent.container.status),
                    _infoRow('Uptime',
                        _detail!.agent.container.uptimeFormatted),
                    _infoRow('CPU',
                        '${_detail!.agent.container.cpuPercent.toStringAsFixed(1)}%'),
                    _infoRow('Memory',
                        _detail!.agent.container.memFormatted),
                    _infoRow('Restarts',
                        '${_detail!.agent.container.restartCount}'),
                    const SizedBox(height: 12),

                    // Sessions 24h
                    Text('Sessions Today',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    if (_detail!.recentSessions.isEmpty)
                      Text('No sessions',
                          style: TextStyle(color: Colors.grey[500]))
                    else
                      ..._detail!.recentSessions
                          .take(20)
                          .map((s) => _SessionRow(s)),
                    const SizedBox(height: 12),

                    // Config
                    if (_detail!.configYaml != null) ...[
                      Text('Config',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1117),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _detail!.configYaml!,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[300],
                              fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ],
                ),
    );
  }

  Widget _infoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13))),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    color: color ?? Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

// ── Session Row ──────────────────────────────────────────────────

class _SessionRow extends StatelessWidget {
  final SessionSummary session;
  const _SessionRow(this.session);

  @override
  Widget build(BuildContext context) {
    final dur = session.durationSecs;
    final durStr =
        '${(dur ~/ 60).toInt()}m ${(dur % 60).toInt()}s';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title ?? session.sessionId,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${session.messageCount} msgs • \$${session.estimatedCost.toStringAsFixed(4)}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Text(durStr,
              style: TextStyle(fontSize: 11, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

// ── Git Card ─────────────────────────────────────────────────────

class _GitCard extends StatelessWidget {
  final dynamic git;
  const _GitCard(this.git);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.code, color: Colors.blueAccent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${git['repo']} (${git['branch']})',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text('${git['last_commit_msg']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if ((git['uncommitted_changes'] ?? 0) > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('+${git['uncommitted_changes']}',
                  style: const TextStyle(
                      fontSize: 10, color: Colors.orangeAccent)),
            ),
        ],
      ),
    );
  }
}
