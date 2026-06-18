import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _relationship = 'Spouse';
  String _gender = 'Female';
  String _bloodGroup = 'A+';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final members = state.familyMembers;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Family Members'),
            Text(
              '${members.length - 1} members added',
              style: TextStyle(
                fontSize: 12,
                color: theme.brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: AppTheme.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              onPressed: () => _showAddMemberSheet(context, state),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo card banner
              _buildFamilyPromoBanner(theme),
              const SizedBox(height: 24),

              // Your Profile
              Text(
                'YOUR PROFILE',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              _buildPrimaryUserCard(state.primaryUser, theme),
              const SizedBox(height: 28),

              // Family Members List
              Text(
                'FAMILY MEMBERS',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              if (members.length <= 1)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'No family members added yet. Click the + button at the top to add.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length - 1, // Exclude self
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final member = members[index + 1]; // Skip self
                    return _buildFamilyMemberCard(context, state, member, theme);
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyPromoBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book for Your Family',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add family members to book tests and manage appointments for them easily.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: theme.brightness == Brightness.dark ? Colors.grey.shade300 : Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryUserCard(FamilyMember user, ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppTheme.blueGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name} (You)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Primary Account',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatsItem('Age', user.age.toString()),
              _buildStatsItem('Gender', user.gender),
              _buildStatsItem('Blood', user.bloodGroup),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyMemberCard(BuildContext context, AppState state, FamilyMember member, ThemeData theme) {
    // Determine avatar background color
    Color avatarBgColor = AppTheme.primaryBlue;
    if (member.relationship == 'Spouse') {
      avatarBgColor = AppTheme.primaryBlue;
    } else if (member.relationship == 'Son') {
      avatarBgColor = AppTheme.purpleAmethyst;
    } else if (member.relationship == 'Daughter') {
      avatarBgColor = Colors.pink;
    }

    final initials = member.name.split(' ').map((e) => e[0]).take(2).join().toUpperCase();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                // Initials Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: avatarBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Member details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        member.relationship,
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Edit & Delete row
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Edit ${member.name} simulation!'), behavior: SnackBarBehavior.floating),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.coralRed),
                  onPressed: () {
                    _showDeleteConfirmation(context, state, member);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),

            // Age/Gender/Blood details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMemberSubDetail(theme, 'Age', '${member.age} yrs'),
                _buildMemberSubDetail(theme, 'Gender', member.gender),
                _buildMemberSubDetail(theme, 'Blood Group', member.bloodGroup),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberSubDetail(ThemeData theme, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, AppState state, FamilyMember member) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Family Member'),
          content: Text('Are you sure you want to remove ${member.name} from your profile?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                state.deleteFamilyMember(member.id);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: AppTheme.coralRed)),
            ),
          ],
        );
      },
    );
  }

  void _showAddMemberSheet(BuildContext context, AppState state) {
    _nameController.clear();
    _ageController.clear();
    _relationship = 'Spouse';
    _gender = 'Female';
    _bloodGroup = 'A+';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Add Family Member',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Enter name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          // Age Field
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Age (Years)',
                                hintText: 'Enter age',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter age';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Relationship Dropdown
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _relationship,
                              decoration: const InputDecoration(
                                labelText: 'Relationship',
                                border: OutlineInputBorder(),
                              ),
                              items: ['Spouse', 'Son', 'Daughter', 'Parent', 'Sibling']
                                  .map((rel) => DropdownMenuItem(value: rel, child: Text(rel)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => _relationship = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          // Gender Dropdown
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                border: OutlineInputBorder(),
                              ),
                              items: ['Male', 'Female', 'Other']
                                  .map((gen) => DropdownMenuItem(value: gen, child: Text(gen)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => _gender = val);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Blood Group Dropdown
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _bloodGroup,
                              decoration: const InputDecoration(
                                labelText: 'Blood Group',
                                border: OutlineInputBorder(),
                              ),
                              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                                  .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setModalState(() => _bloodGroup = val);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            state.addFamilyMember(
                              _nameController.text,
                              _relationship,
                              int.parse(_ageController.text),
                              _gender,
                              _bloodGroup,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${_nameController.text} added to family!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Add Member', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
