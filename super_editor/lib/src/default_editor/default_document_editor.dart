import 'package:super_editor/src/core/document_composer.dart';
import 'package:super_editor/src/core/document_editor.dart';
import 'package:super_editor/src/default_editor/list_items.dart';
import 'package:super_editor/src/default_editor/multi_node_editing.dart';
import 'package:super_editor/src/default_editor/paragraph.dart';
import 'package:super_editor/src/default_editor/text.dart';

import 'common_editor_operations.dart';
import 'default_document_editor_reactions.dart';

DocumentEditor createDefaultDocumentEditor({
  required MutableDocument document,
  DocumentComposer? composer,
}) {
  composer ??= DocumentComposer();

  final editor = DocumentEditor(
    editables: {
      DocumentEditor.documentKey: document,
      DocumentEditor.composerKey: composer,
    },
    requestHandlers: defaultRequestHandlers,
    reactionPipeline: [
      LinkifyReaction(),
      UnorderedListItemConversionReaction(),
      OrderedListItemConversionReaction(),
      BlockquoteConversionReaction(),
      HorizontalRuleConversionReaction(),
      ImageUrlConversionReaction(),
    ],
    listeners: [
      FunctionalEditorChangeListener(
        document.onDocumentChange,
      ),
      FunctionalEditorChangeListener(
        composer.selectionComponent.onEditorChange,
      ),
    ],
  );

  return editor;
}

final defaultRequestHandlers = [
  (request) => request is ChangeSelectionRequest
      ? ChangeSelectionCommand(
          request.newSelection,
          request.changeType,
          request.reason,
          notifyListeners: request.notifyListeners,
        )
      : null,
  (request) => request is InsertTextRequest
      ? InsertTextCommand(
          documentPosition: request.documentPosition,
          textToInsert: request.textToInsert,
          attributions: request.attributions,
        )
      : null,
  (request) => request is InsertNodeAtIndexRequest
      ? InsertNodeAtIndexCommand(nodeIndex: request.nodeIndex, newNode: request.newNode)
      : null,
  (request) => request is InsertNodeBeforeNodeRequest
      ? InsertNodeBeforeNodeCommand(existingNodeId: request.existingNodeId, newNode: request.newNode)
      : null,
  (request) => request is InsertNodeAfterNodeRequest
      ? InsertNodeAfterNodeCommand(existingNodeId: request.existingNodeId, newNode: request.newNode)
      : null,
  (request) => request is InsertNodeAtCaretRequest //
      ? InsertNodeAtCaretCommand(newNode: request.node)
      : null,
  (request) => request is MoveNodeRequest //
      ? MoveNodeCommand(nodeId: request.nodeId, newIndex: request.newIndex)
      : null,
  (request) => request is CombineParagraphsRequest
      ? CombineParagraphsCommand(firstNodeId: request.firstNodeId, secondNodeId: request.secondNodeId)
      : null,
  (request) => request is ReplaceNodeRequest
      ? ReplaceNodeCommand(existingNodeId: request.existingNodeId, newNode: request.newNode)
      : null,
  (request) => request is ReplaceNodeWithEmptyParagraphWithCaretRequest
      ? ReplaceNodeWithEmptyParagraphWithCaretCommand(nodeId: request.nodeId)
      : null,
  (request) =>
      request is DeleteSelectionRequest ? DeleteSelectionCommand(documentSelection: request.documentSelection) : null,
  (request) => request is DeleteNodeRequest ? DeleteNodeCommand(nodeId: request.nodeId) : null,
  (request) => request is DeleteUpstreamCharacterRequest ? const DeleteUpstreamCharacterCommand() : null,
  (request) => request is DeleteDownstreamCharacterRequest ? const DeleteDownstreamCharacterCommand() : null,
  (request) => request is InsertTextRequest
      ? InsertTextCommand(
          documentPosition: request.documentPosition,
          textToInsert: request.textToInsert,
          attributions: request.attributions)
      : null,
  (request) => request is InsertCharacterAtCaretRequest
      ? InsertCharacterAtCaretCommand(
          character: request.character,
          ignoreComposerAttributions: request.ignoreComposerAttributions,
        )
      : null,
  (request) => request is SplitParagraphRequest
      ? SplitParagraphCommand(
          nodeId: request.nodeId,
          splitPosition: request.splitPosition,
          newNodeId: request.newNodeId,
          replicateExistingMetadata: request.replicateExistingMetadata,
        )
      : null,
  (request) => request is SplitListItemRequest
      ? SplitListItemCommand(
          nodeId: request.nodeId,
          splitPosition: request.splitPosition,
          newNodeId: request.newNodeId,
        )
      : null,
  (request) => request is IndentListItemRequest ? IndentListItemCommand(nodeId: request.nodeId) : null,
  (request) => request is UnIndentListItemRequest ? UnIndentListItemCommand(nodeId: request.nodeId) : null,
  (request) => request is ChangeListItemTypeRequest
      ? ChangeListItemTypeCommand(nodeId: request.nodeId, newType: request.newType)
      : null,
  (request) =>
      request is ConvertListItemToParagraphRequest ? ConvertListItemToParagraphCommand(nodeId: request.nodeId) : null,
  (request) => request is ConvertParagraphToListItemRequest
      ? ConvertParagraphToListItemCommand(nodeId: request.nodeId, type: request.type)
      : null,
  (request) => request is AddTextAttributionsRequest
      ? AddTextAttributionsCommand(documentSelection: request.documentSelection, attributions: request.attributions)
      : null,
  (request) => request is ToggleTextAttributionsRequest
      ? ToggleTextAttributionsCommand(documentSelection: request.documentSelection, attributions: request.attributions)
      : null,
  (request) => request is RemoveTextAttributionsRequest
      ? RemoveTextAttributionsCommand(documentSelection: request.documentSelection, attributions: request.attributions)
      : null,
  (request) => request is ConvertTextNodeToParagraphRequest
      ? ConvertTextNodeToParagraphCommand(nodeId: request.nodeId, newMetadata: request.newMetadata)
      : null,
  (request) => request is PasteEditorRequest
      ? PasteEditorCommand(
          content: request.content,
          pastePosition: request.pastePosition,
          composer: request.composer,
        )
      : null,
];