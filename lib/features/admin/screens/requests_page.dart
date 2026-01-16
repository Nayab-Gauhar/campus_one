import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/widgets/animations/animated_widgets.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  String _selectedFilter = 'Clubs'; 
  final Set<String> _selectedRequests = {};

  void _toggleSelection(String requestId) {
    setState(() {
      if (_selectedRequests.contains(requestId)) {
        _selectedRequests.remove(requestId);
      } else {
        _selectedRequests.add(requestId);
      }
    });
  }

  void _clearSelection() {
    setState(() => _selectedRequests.clear());
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataService>();
    final societiesWithRequests = data.societies.where((s) => s.pendingRequests.isNotEmpty).toList();
    final eventsWithRequests = []; 

    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recruitment Hub', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            Text('Active Requests', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1.0, color: AppTheme.textPrimary)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 80,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              _buildFilterTabs(),
              const SizedBox(height: 24),
              Expanded(
                child: _selectedFilter == 'Clubs'
                    ? (societiesWithRequests.isEmpty ? _buildEmptyState('No pending club join requests.') : _buildClubList(societiesWithRequests))
                    : (eventsWithRequests.isEmpty ? _buildEmptyState('No pending event approvals.') : _buildEventList(eventsWithRequests)),
              ),
            ],
          ),
          if (_selectedRequests.isNotEmpty)
            Positioned(
              bottom: 120, // Avoid overlapping with bottom nav
              left: 24,
              right: 24,
              child: _buildBulkActionBar(data),
            ),
        ],
      ),
    );
  }

  Widget _buildBulkActionBar(DataService data) {
    return FadeSlideEntrance(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
             BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Row(
          children: [
            Text(
              '${_selectedRequests.length} selected',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
            ),
            const Spacer(),
            TextButton(
              onPressed: _clearSelection,
              child: const Text('CANCEL', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 8),
            ScaleOnTap(
              onTap: () {
                // Bulk Approve Logic
                // For simplicity, we assume the requestId format is "societyId:userId"
                for (final id in _selectedRequests) {
                  final parts = id.split(':');
                  if (parts.length == 2) data.approveJoinRequest(parts[0], parts[1]);
                }
                _clearSelection();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.circular(100)),
                child: const Text('APPROVE', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          _buildTab('Clubs', _selectedFilter == 'Clubs'),
          _buildTab('Events', _selectedFilter == 'Events'),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            boxShadow: isSelected ? [BoxShadow(color: AppTheme.primaryColor.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClubList(List<dynamic> societies) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      itemCount: societies.length,
      itemBuilder: (context, sIndex) {
        final society = societies[sIndex];
        return FadeSlideEntrance(
          delay: Duration(milliseconds: 100 * sIndex),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                society.name.toUpperCase(),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textSecondary, letterSpacing: 1),
              ),
              const SizedBox(height: 16),
              ...society.pendingRequests.map<Widget>((userId) {
                final requestId = '${society.id}:$userId';
                return _RequestTile(
                  societyId: society.id,
                  userId: userId,
                  userName: 'Applicant $userId',
                  isSelected: _selectedRequests.contains(requestId),
                  onSelect: () => _toggleSelection(requestId),
                  onLongPress: () => _toggleSelection(requestId),
                );
              }).toList(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventList(List<dynamic> events) {
    return const Center(child: Text("Event list implementation pending"));
  }

  Widget _buildEmptyState(String message) {
    return FadeSlideEntrance(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 64, color: AppTheme.accentColor),
            const SizedBox(height: 24),
            const Text(
              'ALL CAUGHT UP!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
               "You have no pending requests at the moment.",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ScaleOnTap(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text('Review past approvals', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  final String societyId;
  final String userId;
  final String userName;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onLongPress;

  const _RequestTile({
    required this.societyId, 
    required this.userId, 
    required this.userName,
    required this.isSelected,
    required this.onSelect,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.read<DataService>();
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: () => _showApplicantPreview(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : AppTheme.primaryColor.withValues(alpha: 0.04)),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onSelect,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary.withValues(alpha: 0.3)),
                  color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                ),
                child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: isSelected ? Colors.white : AppTheme.surfaceColor, shape: BoxShape.circle),
              child: const Icon(Icons.person_rounded, size: 22, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppTheme.textPrimary)),
                  const Text('Computer Science • 3rd Year', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            if (!isSelected) ...[
              ScaleOnTap(
                onTap: () => _showRejectionModal(context, data, societyId, userId),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.05), shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, color: Colors.red, size: 18)),
              ),
              const SizedBox(width: 8),
              ScaleOnTap(
                onTap: () => data.approveJoinRequest(societyId, userId),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: AppTheme.primaryColor, size: 18)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showApplicantPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(color: AppTheme.surfaceColor, shape: BoxShape.circle),
              child: const Icon(Icons.person, size: 40, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5)),
            Text('24/IT/05 • 3rd Year • IT Department', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  _buildDetailRow('Events', 'Inkfinity, DesignX'),
                  const Divider(height: 24, color: Color(0x1F000000)),
                  _buildDetailRow('WhatsApp', '+91 9876543210'),
                  const Divider(height: 24, color: Color(0x1F000000)),
                  _buildDetailRow('Txn ID', 'TXN98230582'),
                  const SizedBox(height: 16),
                  Container(
                    height: 48,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_search_rounded, size: 18, color: AppTheme.primaryColor),
                        SizedBox(width: 8),
                        Text('VIEW PAYMENT PROOF', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ScaleOnTap(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text('Back', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showRejectionModal(BuildContext context, DataService data, String societyId, String userId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reason for Rejection', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            const Text('Help the applicant understand why.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            _buildReasonOption(context, 'Profile Incomplete'),
            _buildReasonOption(context, 'Does not meet criteria'),
            _buildReasonOption(context, 'Capacity Reached'),
            _buildReasonOption(context, 'Other'),
            const SizedBox(height: 32),
            ScaleOnTap(
              onTap: () {
                data.rejectJoinRequest(societyId, userId);
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text('Confirm Rejection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonOption(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary)),
            const Spacer(),
            const Icon(Icons.radio_button_off_rounded, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
